{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = true;
      # 移除未在配置中列出的所有 brew/cask（声明式管理）
      cleanup = "uninstall";
    };

    global.brewfile = true;

    # 要安装的 brew 命令行工具
    brews = [
    ];

    # 要安装的 cask 图形化应用
    casks = [
      "betterdisplay"
      "cmake-app"
      "dingtalk"
      "docker-desktop"
      "feishu"
      "firefox@developer-edition"
      "geekbench"
      "gimp"
      "google-chrome"
      "kitty"
      "libreoffice"
      "macs-fan-control"
      "microsoft-remote-desktop"
      "microsoft-teams"
      "miniconda"
      "mos"
      "motrix"
      "obs"
      "obsidian"
      "raycast"
      "steam"
      "sublime-text"
      "zed"
    ];
  };
}
