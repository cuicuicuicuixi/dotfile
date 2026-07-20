# macOS 系统设置（nix-darwin 专属）
# ================================
# 仅包含 macOS 特有功能：
#   - Touch ID sudo 认证
#   - nix-daemon HTTP 代理注入
#   - Dock / Finder / 触控板 / 截图等系统默认值
#
# 此模块在 Linux 上不可用。

{ self, lib, primaryUser, proxyAddr, ... }:
{
  # sudo 认证：Touch ID（优先）+ Apple Watch（Touch ID 失败时降级）
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    watchIdAuth = true;
  };

  # 自动清理旧世代，防止磁盘吃满
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  # 给 nix-daemon 注入代理环境变量（仅当本机私有配置设置了代理端口时）
  launchd.daemons.nix-daemon = lib.mkIf (proxyAddr != null) {
    serviceConfig.EnvironmentVariables = {
      http_proxy = proxyAddr;
      https_proxy = proxyAddr;
    };
  };

  system = {
    primaryUser = primaryUser;
    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 6;

    defaults = {
      dock = {
        autohide = false; # 关闭自动隐藏 Dock
        largesize = 110; # Dock 放大时最大图标尺寸
        tilesize = 45; # Dock 默认图标尺寸
        magnification = true; # 启用 Dock 放大效果
      };
      finder = {
        ShowPathbar = true; # 底部显示路径栏
        ShowStatusBar = false; # 底部显示状态栏（文件数/剩余空间）
        FXDefaultSearchScope = "SCcf"; # 搜索默认当前文件夹
        _FXShowPosixPathInTitle = false; # 标题栏显示 POSIX 完整路径
      };
      NSGlobalDomain = {
        ApplePressAndHoldEnabled = false; # 禁用长按弹出重音符（写代码必关）
        AppleShowAllExtensions = true; # 显示所有文件后缀名
        KeyRepeat = 2; # 按键重复速度（越小越快，默认 6）
        InitialKeyRepeat = 15; # 首次重复延迟（越小越快，默认 25）
      };
      screencapture = {
        "disable-shadow" = true; # 窗口截图去掉阴影
      };
      trackpad = {
        Clicking = true; # 轻点来点按
        TrackpadThreeFingerDrag = true; # 三指拖拽
      };
    };
  };
}
