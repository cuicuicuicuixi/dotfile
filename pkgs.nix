{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    git
    htop
    curl
    wget
    neovim
    typst
  ];
}
