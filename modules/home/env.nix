# 环境变量 + PATH（跨平台，平台条件路径）
# =========================================
# 通用路径（.cargo/bin、.local/bin 等）在所有平台生效。
# macOS 专属路径（如 anaconda3）用 lib.optionals isDarwin 条件包裹，
# Linux 下自动跳过。

{
  pkgs,
  lib,
  ...
}:
{
  home = {
    sessionVariables = {
      MANPAGER = "nvim +Man!";
      MANWIDTH = "999";
      GOPATH = "$HOME/.local/share/go";
    };
    sessionPath =
      [
        # ---- 跨平台通用 ----
        "$HOME/.local/bin"
        "$HOME/.cargo/bin"
        "$HOME/.local/share/go/bin"
        # fnm PATH 由 shellrc.sh 中 eval "$(fnm env)" 动态管理
        "$HOME/.local/share/neovim/bin"
        "$HOME/.docker/bin"
      ]
      # ---- macOS 专属 ----
      ++ lib.optionals pkgs.stdenv.isDarwin [
        "/opt/homebrew/anaconda3/bin"
      ];
  };
}
