{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = true;
      # 'zap'：移除所有未在配置中列出的 casks（谨慎使用）
      # cleanup = "uninstall";
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

    # 可选：指定 Brewfile 路径（如果不使用上面的 brews/casks 声明）
    # brewfile = ./Brewfile;
  };
}
