{
  lib,
  self,
  ...
}:
{
  programs.zoxide.enable = true;
  programs.starship.enable = true;
  xdg.configFile."starship.toml".source = "${self}/dotfiles/starship.toml";
  xdg.configFile."ghostty/config".source = "${self}/dotfiles/ghostty";
  xdg.configFile."fastfetch/config.jsonc".source = "${self}/dotfiles/fastfetch/config.jsonc";
  xdg.configFile."fastfetch/startup.jsonc".source = "${self}/dotfiles/fastfetch/startup.jsonc";
  xdg.configFile."wezterm/wezterm.lua".source = "${self}/dotfiles/wezterm.lua";

  programs.zsh = lib.mkMerge [
    {
      enable = true;
      history = {
        size = 1000000;
        save = 1000000;
        path = "$HOME/.zsh_history";
        ignoreDups = true;
        share = true;
      };
      shellAliases = {
        # ls 系列
        ls = "eza --icons --group-directories-first";
        ll = "eza --icons --group-directories-first -hl";
        exa = "eza";
        l = "ls -la";
        # 编辑
        vim = "nvim";
        nvimrc = "nvim ~/.config/nvim/";
        # git
        g = "lazygit";
        m = "git checkout master";
        s = "git checkout stable";
        # brew
        bs = "brew search";
        bi = "brew install";
        bu = "brew uninstall";
        bl = "brew list";
        # grep
        grep = "grep --color";
        egrep = "egrep --color=auto";
        fgrep = "fgrep --color=auto";
        # 安全
        cp = "cp -i";
        mv = "mv -i";
        rm = "rm -i";
        # 磁盘
        df = "df -h";
        free = "free -m";
        # 进程
        psmem = "ps auxf | sort -nr -k 4 | head -5";
        pscpu = "ps auxf | sort -nr -k 3 | head -5";
        # 杂项
        neofetch = "fastfetch";
      };
    }
    {
      initContent = ''
        eval "$(fnm env)"
      '';
    }
    {
      initContent = lib.mkOrder 550 ''
        [ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"
      '';
    }
    {
      initContent = ''
        ${builtins.readFile "${self}/dotfiles/zshrc.sh"}
      '';
    }
  ];
}
