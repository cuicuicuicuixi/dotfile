# Shell 配置入口
# ==============
# my.shell 选项控制使用 Zsh（默认，所有平台）还是 Bash（仅 Linux，作为后备）。
# 两个 Shell 模块都会被导入，但内部用 lib.mkIf 按选项条件启用。

{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  cfg = config.my.shell;
in
{
  # ---- 选项 ----
  options.my.shell = lib.mkOption {
    type = lib.types.enum [ "zsh" "bash" ];
    default = "zsh";
    description = "选择默认 Shell 配置（Bash 仅 Linux 有效）";
  };

  # ---- 模块导入（无条件导入全部，内部用 mkIf 条件化） ----
  imports = [
    ./shell/starship.nix
    ./shell/tmux.nix
    ./shell/lazyvim.nix
    ./shell/zsh.nix
    ./shell/bash.nix
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    ./shell/ghostty.nix
    ./shell/kitty.nix
  ];

  config = {
    # ---- 公共程序配置 ----
    programs.fzf.enable = true;
    programs.zoxide.enable = true;
    programs.bat = {
      enable = true;
      config.theme = "gruvbox-dark";
      extraPackages = with pkgs.bat-extras; [
        batman    # 带高亮的 man 页面
        batdiff   # 带语法高亮的 git diff
        batgrep   # 带语法高亮的 grep
        batwatch  # 带语法高亮的 watch
      ];
    };

    programs.eza.enable = true;
    programs.eza.icons = "auto";
    programs.eza.git = true;

    programs.ripgrep.enable = true;

    # direnv（按 shell 启用对应集成）
    programs.direnv.enable = true;
    programs.direnv.enableZshIntegration = cfg == "zsh";
    programs.direnv.enableBashIntegration = cfg == "bash";
    programs.direnv.nix-direnv.enable = true;

    # 配置文件链接
    xdg.configFile."fastfetch/config.jsonc".source = "${self}/dotfiles/fastfetch/config.jsonc";
    xdg.configFile."fastfetch/startup.jsonc".source = "${self}/dotfiles/fastfetch/startup.jsonc";
    xdg.configFile."wezterm/wezterm.lua".source = "${self}/dotfiles/wezterm.lua";
  };
}
