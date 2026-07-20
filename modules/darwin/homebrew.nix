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

    # 要安装的 cask 图形化应用
    casks = [
      "betterdisplay"
      "dingtalk"

      "feishu"
      "firefox@developer-edition"
      "geekbench"
      "gimp"
      "google-chrome"

      "macs-fan-control"
      "microsoft-remote-desktop"
      "microsoft-teams"
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
