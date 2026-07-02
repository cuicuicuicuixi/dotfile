{
  ...
}:
{
  programs.tmux = {
    enable = true;
    mouse = true;
    baseIndex = 1;
    escapeTime = 10;

    extraConfig = ''
      # ---- 快捷键 ----
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      unbind ^B
      bind ^B select-pane -t :.+

      bind h split-window -v
      bind v split-window -h

      # ---- 调整分屏大小 ----
      bind -r - resize-pane -D 2
      bind -r = resize-pane -U 2
      bind -r 0 resize-pane -R 2
      bind -r 9 resize-pane -L 2

      # ---- 切换窗口 ----
      bind -r [ previous-window
      bind -r ] next-window

      # ---- 分屏基础索引 ----
      set -g pane-base-index 1

      # ---- 状态栏 ----
      set -g status-position top
      set -g status-right-length "100"
      set -g status-left-length "100"
      set -g status-style bg=#141A1F,fg=#3D4F5C
      set -g window-status-style fg=#3D4F5C,bg=#141A1F
      setw -g window-status-separator " "
      set -g window-status-current-style fg=colour198
      set -g window-status-format "(#I) #W"
      set -g window-status-current-format "(#I) #W"
      set -g status-left "#[fg=#0D0D0D,bg=#75BDF0] #S #[bg=#3D4F5C,fg=#75BDF0] #h #[bg=#141A1F] "
      set -g status-right "#[bg=#3D4F5C,fg=#75BDF0] %H:%M #[fg=#0D0D0D,bg=#75BDF0] %A %d. %b %Y "

      # ---- 消息/模式样式 ----
      set -g message-command-style fg=#FF007C
      set -g message-style "fg=#FF007C, bg=#141A1F"
      set -g mode-style "fg=#FF007C"

      # ---- 分屏边框 ----
      set -g pane-border-style "fg=#3D4F5C"
      set -g pane-active-border-style "fg=#3D4F5C"

      # ---- UTF-8 ----
      set -q -g status-utf8 on
      setw -q -g utf8 on
    '';
  };
}
