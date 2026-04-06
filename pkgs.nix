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
    just
    fd

    # nix
    nixfmt
    statix

    # rust
    rustc
    cargo
  ];
}
