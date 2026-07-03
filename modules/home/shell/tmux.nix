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

      # ---- 状态栏（Gruvbox Material Dark） ----
      set -g status-position bottom
      set -g status-right-length "100"
      set -g status-left-length "100"
      set -g status-style bg=#1d2021,fg=#928374
      set -g window-status-style fg=#928374,bg=#1d2021
      setw -g window-status-separator " "
      set -g window-status-current-style fg=#d4be98
      set -g window-status-format "(#I) #W"
      set -g window-status-current-format "(#I) #W"
      set -g status-left "#[fg=#1d2021,bg=#d3869b] #S #[bg=#504945,fg=#d3869b] #h #[bg=#1d2021] "
      set -g status-right "#[bg=#504945,fg=#d3869b] %H:%M #[fg=#1d2021,bg=#d3869b] %A %d. %b %Y "

      # ---- 消息/模式样式 ----
      set -g message-command-style fg=#d3869b
      set -g message-style "fg=#d3869b, bg=#1d2021"
      set -g mode-style "fg=#d3869b"

      # ---- 分屏边框 ----
      set -g pane-border-style "fg=#504945"
      set -g pane-active-border-style "fg=#504945"

    '';
  };
}
