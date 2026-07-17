# --- fnm (Node.js 版本管理) ---
eval "$(fnm env)"

# --- bat 别名 ---
if command -v bat &> /dev/null; then
  alias cat="bat -pp"
fi

# --- 发行版检测（用于 starship 图标） ---
LFILE="/etc/os-release"
MFILE="/System/Library/CoreServices/SystemVersion.plist"
if [[ -f $LFILE ]]; then
  _distro=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
elif [[ -f $MFILE ]]; then
  _distro="macos"
fi

case $_distro in
    *kali*)                  ICON="ﴣ";;
    *arch*)                  ICON=" ";;
    *debian*)                ICON=" ";;
    *raspbian*)              ICON=" ";;
    *ubuntu*)                ICON=" ";;
    *elementary*)            ICON=" ";;
    *fedora*)                ICON=" ";;
    *coreos*)                ICON=" ";;
    *gentoo*)                ICON=" ";;
    *mageia*)                ICON=" ";;
    *centos*)                ICON=" ";;
    *opensuse*|*tumbleweed*) ICON=" ";;
    *sabayon*)               ICON=" ";;
    *slackware*)             ICON=" ";;
    *linuxmint*)             ICON=" ";;
    *alpine*)                ICON=" ";;
    *aosc*)                  ICON=" ";;
    *nixos*)                 ICON=" ";;
    *devuan*)                ICON=" ";;
    *manjaro*)               ICON=" ";;
    *rhel*)                  ICON=" ";;
    *macos*)                 ICON=" ";;
    *)                       ICON=" ";;
esac

export STARSHIP_DISTRO="$ICON"

# --- 代理函数 ---
# 由 nix 在 zsh.nix / bash.nix 中根据本机私有配置的 proxyPort 生成，
# 变更代理端口后需 just switch 生效。

# --- conda（自动检测常见路径） ---
for _conda_base in "$HOME/miniconda3" "$HOME/anaconda3" "$HOME/miniforge3" "/opt/homebrew/Caskroom/miniconda/base"; do
  if [ -f "$_conda_base/etc/profile.d/conda.sh" ]; then
    . "$_conda_base/etc/profile.d/conda.sh"
    break
  fi
done
unset _conda_base

# --- fastfetch ---
if command -v fastfetch >/dev/null 2>&1; then
    fastfetch --config "$HOME/.config/fastfetch/startup.jsonc"
fi
