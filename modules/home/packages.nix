# 用户级命令行包（跨平台）
# ==========================
# 使用 home.packages（而非 environment.systemPackages）以兼容：
#   - macOS（nix-darwin + home-manager）
#   - NixOS（nixosSystem + home-manager）
#   - 其他 Linux（独立 home-manager）
#
# 所有包均由 nixpkgs 按 hostPlatform 自动选择对应架构/平台版本，
# 无需手动平台条件。

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # ---- 编辑器 ----
    vim
    # neovim 由 home-manager nixvim 管理

    # ---- 版本控制 ----
    git
    git-lfs
    lazygit

    # ---- Shell 工具 ----
    starship # shell 提示符
    # fzf 由 programs.fzf 管理（shell.nix）
    zoxide # 智能目录跳转
    fd # 快速文件查找
    # ripgrep 由 programs.ripgrep 管理（shell.nix）
    # bat 由 programs.bat 管理（shell.nix）
    # eza 由 programs.eza 管理（shell.nix）
    zk # zsh 配置管理器
    shellcheck # shell 脚本 lint

    # ---- 系统监控 ----
    htop
    btop
    fastfetch # 系统信息展示

    # ---- Diff 工具 ----
    difftastic # 语法感知 diff
    delta # 美化 git diff 输出

    # ---- 终端/开发工具 ----
    wezterm # 终端模拟器（配置由 dotfiles/wezterm.lua 管理，shell.nix 链接）
    tmux # 终端复用器
    just # 命令运行器 (Make 替代)
    fnm # Node.js 版本管理

    # ---- 文档/排版 ----
    typst # 现代排版系统
    glow # 终端 Markdown 渲染
    poppler # PDF 工具 (pdf2image)

    # ---- 语言运行时 ----
    rustc
    cargo

    # ---- 构建工具 ----
    cmake
    pkgconf

    # ---- Nix 工具 ----
    nixfmt # Nix 代码格式化
    # statix         # Nix 代码 lint (测试挂掉)

    # ---- 网络 ----
    curl
    wget
    yt-dlp # 视频下载
    inetutils # telnet 等网络工具

    # ---- 多媒体/图像 ----
    graphviz # 图形可视化
    imagemagick # 图像处理

    # ---- 工具 ----
    gnused # GNU sed
    p7zip # 7z 压缩
    luarocks # Lua 包管理器
    stylua # Lua 格式化
    trash-cli # 命令行回收站
    usbutils # USB 设备工具

    # ---- AI ----
    claude-code
  ];
}
