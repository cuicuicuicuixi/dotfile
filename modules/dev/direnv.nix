# direnv + nix-direnv 集成
# ==========================
# 在所有平台上启用 direnv，并按当前 Shell 选择对应的集成方式。
# nix-direnv 让 direnv 直接使用 flake.nix 提供的 devShell，无需手动维护 .envrc。

{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = config.my.shell == "zsh";
  programs.direnv.enableBashIntegration = config.my.shell == "bash";
  programs.direnv.nix-direnv.enable = true;
}
