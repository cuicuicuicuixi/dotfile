# 字体安装（跨平台）
# ====================
# 使用 home.packages 而非 darwin 的 fonts.packages，
# 使字体在 macOS 和 Linux 上统一通过 home-manager 安装。

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    noto-fonts-cjk-sans
    source-han-sans
    source-han-serif
  ];
}
