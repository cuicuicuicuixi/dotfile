{
  lib,
  self,
  ...
}:
{
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
        ls = "eza --icons --group-directories-first";
        ll = "eza --icons --group-directories-first -hl";
        exa = "eza";
        l = "ls -la";
        grep = "grep --color";
        vim = "nvim";
      };
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
