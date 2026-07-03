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
  primaryUser,
  ...
}:
{
  imports = [
    ./system.nix # NixOS 基础系统设置（boot、locale、zsh）
  ];

  # ---- Linux 用户创建 ----
  users.users.${primaryUser} = {
    isNormalUser = true;
    home = "/home/${primaryUser}";
    shell = pkgs.zsh;
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
      inherit inputs self primaryUser;
    };
  };
}
