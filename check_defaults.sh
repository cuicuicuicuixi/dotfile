#!/bin/bash
# 查看当前 macOS defaults 配置值

echo "=== 键盘 ==="
echo -n "KeyRepeat: "; defaults read NSGlobalDomain KeyRepeat 2>/dev/null || echo "(unset)"
echo -n "InitialKeyRepeat: "; defaults read NSGlobalDomain InitialKeyRepeat 2>/dev/null || echo "(unset)"
echo -n "ApplePressAndHoldEnabled: "; defaults read NSGlobalDomain ApplePressAndHoldEnabled 2>/dev/null || echo "(unset)"

echo ""
echo "=== 触控板 ==="
echo -n "Clicking: "; defaults read com.apple.AppleMultitouchTrackpad Clicking 2>/dev/null || echo "(unset)"
echo -n "ThreeFingerDrag: "; defaults read com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag 2>/dev/null || echo "(unset)"

echo ""
echo "=== Finder ==="
echo -n "AppleShowAllExtensions: "; defaults read NSGlobalDomain AppleShowAllExtensions 2>/dev/null || echo "(unset)"
echo -n "ShowPathbar: "; defaults read com.apple.finder ShowPathbar 2>/dev/null || echo "(unset)"
echo -n "ShowStatusBar: "; defaults read com.apple.finder ShowStatusBar 2>/dev/null || echo "(unset)"
echo -n "FXDefaultSearchScope: "; defaults read com.apple.finder FXDefaultSearchScope 2>/dev/null || echo "(unset)"
echo -n "_FXShowPosixPathInTitle: "; defaults read com.apple.finder _FXShowPosixPathInTitle 2>/dev/null || echo "(unset)"

echo ""
echo "=== 截图 ==="
echo -n "disable-shadow: "; defaults read com.apple.screencapture disable-shadow 2>/dev/null || echo "(unset)"
echo -n "location: "; defaults read com.apple.screencapture location 2>/dev/null || echo "(unset)"
echo -n "type: "; defaults read com.apple.screencapture type 2>/dev/null || echo "(unset)"
