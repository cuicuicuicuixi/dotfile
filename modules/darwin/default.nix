# macOS 系统配置（nix-darwin 顶层模块）
# ======================================
# 职责：
#   1. 导入 macOS 专属子模块（system、homebrew）
#   2. 创建用户 + 系统级路径
#   3. 集成 home-manager（用户级配置统一走 ../home）
#
# 注意：跨平台的用户配置（包、字体、shell、git 等）
# 已迁入 ../home/，此模块仅保留 macOS 专有设置。

{
  lib,
  pkgs,
  inputs,
  self,
  primaryUser,
  ...
}:
{
  imports = [
    ./system.nix # macOS 系统默认值、PAM、launchd 代理
    ./homebrew.nix # Homebrew casks/brews
  ];

  # ---- macOS 系统级设置 ----
  system.primaryUser = primaryUser;
  users.users.${primaryUser} = {
    home = "/Users/${primaryUser}";
    shell = pkgs.zsh;
  };

  environment = {
    systemPath = [
      "/opt/homebrew/bin"
    ];
    pathsToLink = [ "/Applications" ];
  };

  # ---- home-manager 集成 ----
  # 用户级配置统一从 ../home 导入，与 NixOS 共享同一套模块
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
