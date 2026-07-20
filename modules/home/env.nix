# 环境变量 + PATH（跨平台，平台条件路径）
# =========================================
# 通用路径（.cargo/bin、.local/bin 等）在所有平台生效。
# macOS 专属路径（如 anaconda3）用 lib.optionals isDarwin 条件包裹，
# Linux 下自动跳过。

{
  config,
  pkgs,
  lib,
  ...
}:
{
  home = {
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      MANPAGER = "nvim +Man!";
      MANWIDTH = "999";
      GOPATH = "${config.home.homeDirectory}/.local/share/go";
    }
    // lib.optionalAttrs pkgs.stdenv.isLinux {
      # 让发行版自带的 clear/tput 等程序找到 Home Manager 安装的 terminfo。
      TERMINFO_DIRS = "${config.home.profileDirectory}/share/terminfo:/etc/terminfo:/lib/terminfo:/usr/share/terminfo";
    };
    sessionPath =
      [
        # ---- 跨平台通用 ----
        "${config.home.homeDirectory}/.local/bin"
        "${config.home.homeDirectory}/.cargo/bin"
        "${config.home.homeDirectory}/.local/share/go/bin"
        # fnm PATH 由 shellrc.sh 中 eval "$(fnm env)" 动态管理
        "${config.home.homeDirectory}/.local/share/neovim/bin"
        "${config.home.homeDirectory}/.docker/bin"
      ]
      # ---- macOS 专属 ----
      ++ lib.optionals pkgs.stdenv.isDarwin [
        "/opt/homebrew/anaconda3/bin"
      ];
  };
}
