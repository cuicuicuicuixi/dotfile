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
  localConfig,
  primaryUser,
  ...
}:
{
  imports = [
    ../dev
    ./git.nix
    ./shell.nix
    ./env.nix
    ./packages.nix
    ./fonts.nix
    ./ssh.nix
  ];

  # macOS 固定使用 Zsh；Linux 使用 config.sh 的检测结果，旧配置默认 Zsh。
  my.shell = if pkgs.stdenv.isDarwin then "zsh" else localConfig.shell or "zsh";

  home = {
    # 跨平台 home 目录：macOS /Users，Linux /home
    homeDirectory =
      if pkgs.stdenv.isDarwin then
        "/Users/${primaryUser}"
      else if primaryUser == "root" then
	"/root"
      else
        "/home/${primaryUser}";
    username = primaryUser;
    stateVersion = "25.05";
  };
}
