#!/usr/bin/env bash
# 打印当前系统配置属性（按平台分组）
set -e

os="$(uname -s)"

case "$os" in
  Darwin)
    echo "=== macOS 系统配置 ==="
    echo ""

    echo "--- 键盘 ---"
    echo -n "  KeyRepeat:                        "; defaults read NSGlobalDomain KeyRepeat 2>/dev/null || echo "(unset)"
    echo -n "  InitialKeyRepeat:                 "; defaults read NSGlobalDomain InitialKeyRepeat 2>/dev/null || echo "(unset)"
    echo -n "  ApplePressAndHoldEnabled:         "; defaults read NSGlobalDomain ApplePressAndHoldEnabled 2>/dev/null || echo "(unset)"

    echo ""
    echo "--- 触控板 ---"
    echo -n "  点按单击:                         "; defaults read com.apple.AppleMultitouchTrackpad Clicking 2>/dev/null || echo "(unset)"
    echo -n "  三指拖拽:                         "; defaults read com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag 2>/dev/null || echo "(unset)"
    echo -n "  滚动方向(自然):                   "; defaults read NSGlobalDomain com.apple.swipescrolldirection 2>/dev/null || echo "(unset)"

    echo ""
    echo "--- 鼠标 ---"
    echo -n "  滚动方向(自然):                   "; defaults read NSGlobalDomain com.apple.swipescrolldirection 2>/dev/null || echo "(unset)"

    echo ""
    echo "--- Finder ---"
    echo -n "  显示文件扩展名:                   "; defaults read NSGlobalDomain AppleShowAllExtensions 2>/dev/null || echo "(unset)"
    echo -n "  显示路径栏:                       "; defaults read com.apple.finder ShowPathbar 2>/dev/null || echo "(unset)"
    echo -n "  显示状态栏:                       "; defaults read com.apple.finder ShowStatusBar 2>/dev/null || echo "(unset)"
    echo -n "  搜索范围:                         "; defaults read com.apple.finder FXDefaultSearchScope 2>/dev/null || echo "(unset)"
    echo -n "  标题栏显示 POSIX 路径:            "; defaults read com.apple.finder _FXShowPosixPathInTitle 2>/dev/null || echo "(unset)"
    echo -n "  默认视图模式:                     "; defaults read com.apple.finder FXPreferredViewStyle 2>/dev/null || echo "(unset)"
    echo -n "  显示桌面图标:                     "; defaults read com.apple.finder CreateDesktop 2>/dev/null || echo "(unset)"
    echo -n "  禁用 .DS_Store 网络写入:          "; defaults read com.apple.desktopservices DSDontWriteNetworkStores 2>/dev/null || echo "(unset)"
    echo -n "  新窗口打开路径:                   "; defaults read com.apple.finder NewWindowTarget 2>/dev/null || echo "(unset)"

    echo ""
    echo "--- 截图 ---"
    echo -n "  禁用窗口阴影:                     "; defaults read com.apple.screencapture disable-shadow 2>/dev/null || echo "(unset)"
    echo -n "  保存路径:                         "; defaults read com.apple.screencapture location 2>/dev/null || echo "(unset)"
    echo -n "  格式:                             "; defaults read com.apple.screencapture type 2>/dev/null || echo "(unset)"
    echo -n "  禁用日期后缀:                     "; defaults read com.apple.screencapture include-date 2>/dev/null || echo "(unset)"

    echo ""
    echo "--- Dock ---"
    echo -n "  自动隐藏:                         "; defaults read com.apple.dock autohide 2>/dev/null || echo "(unset)"
    echo -n "  自动隐藏延迟:                     "; defaults read com.apple.dock autohide-delay 2>/dev/null || echo "(unset)"
    echo -n "  自动隐藏动画时间:                 "; defaults read com.apple.dock autohide-time-modifier 2>/dev/null || echo "(unset)"
    echo -n "  图标大小:                         "; defaults read com.apple.dock tilesize 2>/dev/null || echo "(unset)"
    echo -n "  放大效果:                         "; defaults read com.apple.dock magnification 2>/dev/null || echo "(unset)"
    echo -n "  最小化效果:                       "; defaults read com.apple.dock mineffect 2>/dev/null || echo "(unset)"
    echo -n "  显示隐藏应用透明图标:             "; defaults read com.apple.dock showhidden 2>/dev/null || echo "(unset)"
    echo -n "  仅显示运行中的应用:               "; defaults read com.apple.dock static-only 2>/dev/null || echo "(unset)"
    echo -n "  禁用最近应用:                     "; defaults read com.apple.dock show-recents 2>/dev/null || echo "(unset)"

    echo ""
    echo "--- 桌面/窗口 ---"
    echo -n "  Hot Corners (tl/tr/bl/br):        "; defaults read com.apple.dock wvous-tl-corner 2>/dev/null || echo -n "(unset)"; echo -n " / "; defaults read com.apple.dock wvous-tr-corner 2>/dev/null || echo -n "(unset)"; echo -n " / "; defaults read com.apple.dock wvous-bl-corner 2>/dev/null || echo -n "(unset)"; echo -n " / "; defaults read com.apple.dock wvous-br-corner 2>/dev/null || echo "(unset)"

    echo ""
    echo "--- Mission Control ---"
    echo -n "  自动排列空间:                     "; defaults read com.apple.dock mru-spaces 2>/dev/null || echo "(unset)"
    echo -n "  切换时切换到有窗口的空间:         "; defaults read NSGlobalDomain AppleSpacesSwitchOnActivate 2>/dev/null || echo "(unset)"

    echo ""
    echo "--- 菜单栏 ---"
    echo -n "  自动隐藏菜单栏:                   "; defaults read NSGlobalDomain _HIHideMenuBar 2>/dev/null || echo "(unset)"
    echo -n "   菜单显示电池百分比:            "; defaults read com.apple.menuextra.battery ShowPercent 2>/dev/null || echo "(unset)"

    echo ""
    echo "--- 系统 ---"
    echo -n "  HostName:                         "; scutil --get HostName 2>/dev/null || echo "(unset)"
    echo -n "  ComputerName:                     "; scutil --get ComputerName 2>/dev/null || echo "(unset)"
    echo -n "  LocalHostName:                    "; scutil --get LocalHostName 2>/dev/null || echo "(unset)"

    echo ""
    echo "--- 安全 ---"
    echo -n "  密码要求延迟(秒):                 "; defaults read com.apple.screensaver askForPasswordDelay 2>/dev/null || echo "(unset)"

    echo ""
    echo "--- 软件更新 ---"
    echo -n "  自动检查更新:                     "; defaults read com.apple.SoftwareUpdate AutomaticCheckEnabled 2>/dev/null || echo "(unset)"
    echo -n "  自动下载更新:                     "; defaults read com.apple.SoftwareUpdate AutomaticDownload 2>/dev/null || echo "(unset)"
    echo -n "  安装系统数据文件:                 "; defaults read com.apple.SoftwareUpdate CriticalUpdateInstall 2>/dev/null || echo "(unset)"

    echo ""
    echo "--- 磁盘工具 ---"
    echo -n "  显示所有设备:                     "; defaults read com.apple.DiskUtility DUShowEveryPartition 2>/dev/null || echo "(unset)"
    ;;
  Linux)
    if [ -f /etc/NIXOS ] || grep -q NixOS /etc/os-release 2>/dev/null; then
      echo "=== NixOS 系统配置 ==="
      echo "  TODO: NixOS 属性检查"
    else
      echo "=== Linux 系统配置 ==="
      echo "  Kernel: $(uname -r)"
      echo "  TODO: Linux 属性检查"
    fi
    ;;
  *)
    echo "不支持的系统: $os"
    exit 1
    ;;
esac
