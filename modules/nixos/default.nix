# NixOS 系统配置（顶层模块）
# ===========================
# 职责：
#   1. 导入 NixOS 专属子模块（system）
#   2. 创建 Linux 用户 + 权限组
#   3. 集成 home-manager（用户级配置统一走 ../home）
#
# 与 darwin/default.nix 角色对称，共享同一套 ../home/ 用户配置。

{
  pkgs,
  inputs,
  self,
  localConfig,
  primaryUser,
  proxyAddr,
  ...
}:
let
  loginShell = if (localConfig.shell or "zsh") == "bash" then pkgs.bashInteractive else pkgs.zsh;
in
{
  imports = [
    ./system.nix # NixOS 基础系统设置（locale、Shell、stateVersion）
  ];

  # ---- Linux 用户创建 ----
  # root 是已有系统账户，只设置 home/shell；其他用户按普通管理员账户创建。
  users.users.${primaryUser} =
    if primaryUser == "root" then
      {
        home = "/root";
        shell = loginShell;
      }
    else
      {
        isNormalUser = true;
        home = "/home/${primaryUser}";
        shell = loginShell;
        extraGroups = [
          "wheel" # sudo 权限
          "networkmanager" # 网络管理
        ];
      };

  # ---- home-manager 集成 ----
  # 与 darwin/default.nix 完全对称，用户级配置共享同一套 ../home
  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${primaryUser} = {
      imports = [
        ../home
      ];
    };
    extraSpecialArgs = {
      inherit inputs self localConfig primaryUser proxyAddr;
    };
  };
}
