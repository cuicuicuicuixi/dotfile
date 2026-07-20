# Zsh 配置（插件、别名、快捷键、启动脚本）
# ==========================================
# 仅在 my.shell = "zsh" 时启用（默认）。
# 插件从 zap 迁移到 programs.zsh.plugins（Nix 原生管理）
# 自定义启动脚本（代理函数、发行版检测等）保留在 dotfiles/shellrc.sh

{
  config,
  lib,
  pkgs,
  self,
  proxyAddr ? null,
  ...
}:
lib.mkIf (config.my.shell == "zsh") {
  programs.zsh = {
    enable = true;
    history = {
      size = 1000000;
      save = 1000000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      share = true;
      extended = true; # 每条记录带时间戳
    };

    # zsh 插件（原 zap 管理，现由 Nix 原生管理）
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
      {
        name = "zsh-autopair";
        src = pkgs.zsh-autopair;
        file = "share/zsh-autopair/autopair.zsh";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.zsh";
      }
    ];

    # 补全增强：fzf-tab 交互界面 + fzf 模糊匹配引擎
    completionInit = ''
      # fzf-tab: Tab 后继续输入即可模糊筛选，方向键选择
      zstyle ':fzf-tab:*' fzf-flags --height=50% --layout=reverse --border
      zstyle ':fzf-tab:*' continuous-trigger '/'
      zstyle ':completion:*' menu select=1
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|=*' 'l:|=* r:|=*'
    '';

    # 启动脚本（代理函数 + 插件快捷键 + shellrc + zshrc）
    initContent = ''
      # ---- 代理函数（地址由本机私有配置的 proxyHost 和 proxyPort 在 build 时确定） ----
      ${import ./proxy-func.nix proxyAddr}

      bindkey '^ ' autosuggest-accept
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
      # fzf: Ctrl-T 模糊搜索文件 / Ctrl-R 搜索历史

      ${builtins.readFile "${self}/dotfiles/shellrc.sh"}
      ${builtins.readFile "${self}/dotfiles/zshrc.sh"}
    '';

    shellAliases =
      import ./aliases.nix
      // lib.optionalAttrs pkgs.stdenv.isDarwin {
        # Homebrew 别名（仅 macOS）
        bs = "brew search";
        bi = "brew install";
        bu = "brew uninstall";
        bl = "brew list";
      };
  };
}
