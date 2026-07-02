{
  lib,
  pkgs,
  inputs,
  self,
  primaryUser,
  ...
}:
{
  # macOS-specific settings
  system.primaryUser = primaryUser;
  users.users.${primaryUser} = {
    home = "/Users/${primaryUser}";
    shell = pkgs.zsh;
  };

  environment = {
    systemPath = [
      "/opt/homebrew/bin"
    ];
    pathsToLink = [ "/Applications" ];
  };

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${primaryUser} = {
      home = {
        homeDirectory = "/Users/${primaryUser}";
        username = primaryUser;
        stateVersion = "25.05";
        sessionVariables = {
          # shared environment variables
        };
        sessionPath = [
          "$HOME/.local/bin"
          "/opt/homebrew/anaconda3/bin"
          "$HOME/.docker/bin"
        ];
      };
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
            ${builtins.readFile ./dotfiles/zshrc.sh}
          '';
        }
      ];
    };
    extraSpecialArgs = {
      inherit inputs self primaryUser;
    };
  };
}
