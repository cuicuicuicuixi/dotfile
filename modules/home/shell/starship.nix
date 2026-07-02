{
  ...
}:
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      command_timeout = 1000;
      format = ''$env_var$username[@](bold #ea6962)$hostname$directory$git_status$git_branch'';

      character = {
        success_symbol = "[](#928374)";
        error_symbol = "[](#928374)";
      };

      # env_var.STARSHIP_DISTRO（由 zshrc 注入）
      env_var = {
        STARSHIP_DISTRO = {
          format = ''[$env_value](bold #d4be98)'';
          variable = "STARSHIP_DISTRO";
          disabled = false;
        };
      };

      username = {
        style_user = "#d4be98";
        format = "[$\{user}]($style)";
        disabled = false;
        show_always = true;
      };

      hostname = {
        ssh_only = false;
        format = ''[$hostname](#d4be98) '';
        disabled = false;
      };

      localip = {
        ssh_only = true;
        format = ''[@ $localipv4](bold italic #ea6962) '';
        disabled = false;
      };

      status = {
        style = "bold #a9b665";
        symbol = "";
        success_symbol = "";
        not_found_symbol = "";
        not_executable_symbol = "";
        format = ''[$symbol]($style) '';
        map_symbol = true;
        disabled = false;
      };

      directory = {
        truncation_length = 1;
        home_symbol = "~";
        style = "bold #89b482";
        read_only_style = "#ea6962";
        read_only = "  ";
        format = ''[➜](bold #a9b665) [$path]($style)[$read_only]($read_only_style) '';
      };

      git_branch = {
        symbol = "";
        format = ''[$symbol](#d8a657) [$branch]($style)[\)](#7daea3) '';
        truncation_symbol = "/";
        style = "#d3869b";
      };

      git_status = {
        format = ''[\(](#7daea3)[$ahead_behind]($style)[$staged]($style)[$modified]($style)[$deleted]($style)[$renamed]($style)'';
        style = "bold #d3869b";
        ahead = "⇡";
        behind = "⇣";
        diverged = "⇕";
        staged = "+";
        modified = "✚";
        deleted = "✖";
        renamed = "➜";
      };

      fill = {
        symbol = " ";
      };

      python = {
        format = '' [$symbol($version(-$name) )]($style)'';
        symbol = " ";
        python_binary = "python3";
        style = "bold #a9b665";
      };

      nodejs = {
        format = '' [ $version](bold #a9b665) '';
        disabled = true;
      };

      c = {
        format = '' [$symbol($version(-$name) )]($style)'';
        symbol = " ";
        detect_extensions = [ "c" "h" "cpp" "hpp" ];
        detect_folders = [ "src" ];
        style = "bold #7daea3";
      };

      lua = {
        format = '' [$symbol($version(-$name) )]($style)'';
        symbol = " ";
        style = "bold #89b482";
      };
    };
  };
}
