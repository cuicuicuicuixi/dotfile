{
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.stdenv.isDarwin {
  programs.ghostty = {
    enable = true;
    # 按平台选择正确的包
    package = pkgs.ghostty-bin;
    settings = {
      theme = "Gruvbox Material Dark";
      font-family = "MonacoLigaturized";
      font-size = 14;
      mouse-scroll-multiplier = 0.5;
      window-padding-x = 2;
      window-padding-y = 2;
      macos-window-shadow = true;
      window-titlebar-background = "#1d2021";
      window-titlebar-foreground = "#928374";
    };
  };
}
