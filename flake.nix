# 多系统 nix flake（macOS + Linux）
# ================================
#
# 架构：
#   modules/darwin/   — macOS 系统级配置（nix-darwin）
#   modules/nixos/    — NixOS 系统级配置
#   modules/home/     — 跨平台 home-manager 配置（所有系统共享）
#
# 使用方式：
#   macOS:           darwin-rebuild switch --flake .#MacBook-Pro
#   NixOS (x86_64):  nixos-rebuild  switch --flake .#nixos-x86
#   NixOS (arm64):   nixos-rebuild  switch --flake .#nixos-arm
#   其他 Linux:       home-manager  switch --flake .#\<user\>@linux-x86

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
      # 从 local.nix 读取（git tracked + assume-unchanged 保护本地修改）
      primaryUser =
        let localFile = ./modules/home/local.nix;
        in if builtins.pathExists localFile then
          (import localFile).primaryUser
        else
          "user";

      # 所有系统共享的 nix 基础配置（flakes 开关 + unfree 白名单）
      baseNixConfig =
        { pkgs, ... }:
        {
          nix.settings.experimental-features = "nix-command flakes";
          nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
            "claude-code"
          ];
        };
    in
    {
      # ==========================================================
      # macOS — nix-darwin（系统级管理：defaults、PAM、homebrew）
      # ==========================================================
      darwinConfigurations."MacBook-Pro" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          baseNixConfig
          ./modules/darwin # macOS 系统模块（system + homebrew + home-manager 集成）
          home-manager.darwinModules.home-manager
        ];
        specialArgs = {
          inherit inputs self primaryUser;
        };
      };

      # ==========================================================
      # NixOS x86_64 — 系统级管理（boot、systemd、locale 等）
      # ==========================================================
      nixosConfigurations."nixos-x86" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          baseNixConfig
          ./modules/nixos # NixOS 系统模块 + home-manager 集成
          home-manager.nixosModules.home-manager
        ];
        specialArgs = {
          inherit inputs self primaryUser;
        };
      };

      # ==========================================================
      # NixOS aarch64
      # ==========================================================
      nixosConfigurations."nixos-arm" = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          baseNixConfig
          ./modules/nixos
          home-manager.nixosModules.home-manager
        ];
        specialArgs = {
          inherit inputs self primaryUser;
        };
      };

      # ==========================================================
      # 独立 home-manager — 非 NixOS Linux（仅用户级配置）
      # 适用场景：Ubuntu/Arch/Fedora 等发行版，Nix 仅作为包管理器
      # ==========================================================
      homeConfigurations."${primaryUser}@linux-x86" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./modules/home ]; # 仅用户级配置，无系统管理
        extraSpecialArgs = {
          inherit inputs self primaryUser;
        };
      };

      homeConfigurations."${primaryUser}@linux-arm" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        modules = [ ./modules/home ];
        extraSpecialArgs = {
          inherit inputs self primaryUser;
        };
      };
    };
}
