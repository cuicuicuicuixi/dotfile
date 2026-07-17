{
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.stdenv.isDarwin {
  programs.kitty = {
    enable = true;

    settings = {
      # ---- 字体 ----
      font_family = "MonacoLigaturized Nerd Font Mono";
      font_size = 14;

      # ---- 窗口 ----
      window_padding_width = 10;
      hide_window_decorations = "no";
      confirm_os_window_close = 0;
      macos_titlebar_color = "background";

      # ---- 光标 ----
      cursor_shape = "beam";
      cursor_blink_interval = "0.5";
      cursor_trail = 1;
      cursor_trail_decay = "0.1 0.4";
      cursor_trail_start_threshold = 2;

      # ---- Tab 栏 ----
      tab_bar_edge = "top";
      tab_bar_style = "powerline";

      # ---- 背景（纯色不透） ----

      # ---- 滚动 ----
      scrollback_lines = 10240;
      scrollback_pager_history_size = 100;

      # ---- 性能 ----
      repaint_delay = 4;
      input_delay = 1;

      # ---- Gruvbox Material Dark 配色 ----
      foreground = "#d4be98";
      background = "#1d2021";
      selection_foreground = "#1d2021";
      selection_background = "#d4be98";

      # 正常色
      color0 = "#282828";
      color1 = "#ea6962";
      color2 = "#a9b665";
      color3 = "#d8a657";
      color4 = "#7daea3";
      color5 = "#d3869b";
      color6 = "#89b482";
      color7 = "#d4be98";

      # 亮色
      color8 = "#928374";
      color9 = "#ea6962";
      color10 = "#a9b665";
      color11 = "#d8a657";
      color12 = "#7daea3";
      color13 = "#d3869b";
      color14 = "#89b482";
      color15 = "#fbf1c7";

      # Tab 栏颜色
      active_tab_foreground = "#1d2021";
      active_tab_background = "#d4be98";
      inactive_tab_foreground = "#928374";
      inactive_tab_background = "#1d2021";

      # 光标颜色
      cursor = "#d4be98";
      cursor_text_color = "#1d2021";
    };
  };
}
