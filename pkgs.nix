{ pkgs, lib, ... }:
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

    claude-code

    git-lfs

    # 转图片预览
    poppler
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "claude-code" ];
}
