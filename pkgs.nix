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

    # 构建
    cmake

    # 转图片预览
    poppler

    # 从 homebrew 迁移过来的 CLI 工具
    bat
    btop
    emscripten
    eza
    fastfetch
    fnm
    fzf
    glow
    gnused
    graphviz
    imagemagick
    lazygit
    luarocks
    p7zip
    pkgconf
    ripgrep
    shellcheck
    starship
    stylua
    tmux
    trash-cli
    yt-dlp
    zk
    zoxide
    usbutils
    inetutils        # 提供 telnet
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "claude-code" ];
}
