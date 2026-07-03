# Ghostty 终端模拟器（平台感知）
# ================================
# macOS: 使用 ghostty-bin（官方预编译二进制）
# Linux: 使用 ghostty（从源码编译，ghostty-bin 不支持 Linux）
#
# macos-window-shadow 设置仅 macOS 有效，Linux 下无害忽略。

{
  pkgs,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    # 按平台选择正确的包
    package =
      if pkgs.stdenv.isDarwin then
        pkgs.ghostty-bin
      else
        pkgs.ghostty;
    settings = {
      theme = "Gruvbox Material Dark";
      font-family = "MonacoLigaturized Nerd Font Mono";
      mouse-scroll-multiplier = 0.5;
      window-padding-x = 2;
      window-padding-y = 2;
      macos-window-shadow = false;
      window-titlebar-background = "#1d2021";
      window-titlebar-foreground = "#928374";
    };
  };
}
