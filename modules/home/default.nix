# home-manager 用户配置（跨平台入口）
# =====================================
# 此模块被 darwin、nixos、独立 home-manager 三种方式复用。
#
# 平台感知：
#   - homeDirectory: macOS → /Users/${user}, Linux → /home/${user}
#   - 子模块（env、packages 等）内部用 pkgs.stdenv.isDarwin 做平台条件
#
# 导入顺序无依赖关系，各子模块独立。

{
  pkgs,
  primaryUser,
  ...
}:
{
  imports = [
    ./git.nix
    ./shell.nix
    ./env.nix
    ./packages.nix
    ./fonts.nix
  ];

  home = {
    # 跨平台 home 目录：macOS /Users，Linux /home
    homeDirectory =
      if pkgs.stdenv.isDarwin then
        "/Users/${primaryUser}"
      else
        "/home/${primaryUser}";
    username = primaryUser;
    stateVersion = "25.05";
  };
}
