# 多系统 nix flake（macOS + Linux）
# ================================
#
# 架构：
#   modules/darwin/   — macOS 系统级配置（nix-darwin）
#   modules/nixos/    — NixOS 系统级配置
#   modules/home/     — 跨平台 home-manager 配置（所有系统共享）
#
# 使用方式：
#   macOS:           darwin-rebuild switch --flake .#\<hostname\>
#   NixOS:           nixos-rebuild  switch --flake .#\<hostname\>
#   其他 Linux:       home-manager  switch --flake .#\<user\>@\<hostname\>

{
  description = "My multi-system nix flake (macOS + Linux)";

  inputs = {
    # 主包仓库（rolling release，所有平台统一使用同一个 nixpkgs 实例）
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # macOS 系统管理（system.defaults / PAM / launchd / homebrew）
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # 跨平台用户环境管理（dotfiles / 用户级包），作为 nix-darwin 或 NixOS 的子模块运行
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Neovim 发行版打包（LazyVim 集成）
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      # 本机身份配置位于仓库外；纯求值时使用无个人信息的样例值。
      localConfigPath = builtins.getEnv "NIX_LOCAL_CONFIG";
      localConfig =
        if localConfigPath != "" && builtins.pathExists localConfigPath then
          import localConfigPath
        else
          import ./modules/home/local.example.nix;

      primaryUser = localConfig.primaryUser or "user";
      homeHostName = localConfig.hostName or "host";
      homeSystem = localConfig.homeSystem or "x86_64-linux";

      # 代理地址：从本机配置读取端口，null 表示无代理
      proxyAddr =
        let port = localConfig.proxyPort or null;
        in if port == null || port == 0 then null else "http://127.0.0.1:${toString port}";

      # 允许安装的 unfree 包白名单（所有系统共享）
      unfreePackages = [
        "claude-code"
      ];
      allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) unfreePackages;

      # 所有系统共享的 nix 基础配置（flakes 开关 + unfree 白名单）
      baseNixConfig =
        { ... }:
        {
          nix.settings.experimental-features = "nix-command flakes";
          nixpkgs.config.allowUnfreePredicate = allowUnfreePredicate;
        };
    in
    {
      # ==========================================================
      # macOS — 系统配置使用实际主机名作为 Flake 选择器
      # ==========================================================
      darwinConfigurations = nixpkgs.lib.optionalAttrs (nixpkgs.lib.hasSuffix "-darwin" homeSystem) {
        "${homeHostName}" = nix-darwin.lib.darwinSystem {
          system = homeSystem;
          modules = [
            baseNixConfig
            ./modules/darwin # macOS 系统模块（system + homebrew + home-manager 集成）
            home-manager.darwinModules.home-manager
          ];
          specialArgs = {
            inherit inputs self localConfig primaryUser proxyAddr;
          };
        };
      };

      # ==========================================================
      # NixOS — 仅发布已提供真实硬件配置并显式启用的主机
      # ==========================================================
      nixosConfigurations =
        nixpkgs.lib.optionalAttrs
          (homeSystem == "x86_64-linux" && import ./hosts/nixos-x86/enabled.nix)
          {
            "${homeHostName}" = nixpkgs.lib.nixosSystem {
              system = homeSystem;
              modules = [
                baseNixConfig
                ./hosts/nixos-x86
                home-manager.nixosModules.home-manager
              ];
              specialArgs = {
                hostName = homeHostName;
                inherit inputs self localConfig primaryUser proxyAddr;
              };
            };
          }
        // nixpkgs.lib.optionalAttrs
          (homeSystem == "aarch64-linux" && import ./hosts/nixos-arm/enabled.nix)
          {
            "${homeHostName}" = nixpkgs.lib.nixosSystem {
              system = homeSystem;
              modules = [
                baseNixConfig
                ./hosts/nixos-arm
                home-manager.nixosModules.home-manager
              ];
              specialArgs = {
                hostName = homeHostName;
                inherit inputs self localConfig primaryUser proxyAddr;
              };
            };
          };

      # ==========================================================
      # 独立 home-manager — 非 NixOS Linux（仅用户级配置）
      # 适用场景：Ubuntu/Arch/Fedora 等发行版，Nix 仅作为包管理器
      # ==========================================================
      homeConfigurations = {
        "${primaryUser}@${homeHostName}" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = homeSystem;
            config.allowUnfreePredicate = allowUnfreePredicate;
          };
          modules = [ ./modules/home ]; # 仅用户级配置，无系统管理
          extraSpecialArgs = {
            inherit inputs self localConfig primaryUser proxyAddr;
          };
        };
      };
    };
}
