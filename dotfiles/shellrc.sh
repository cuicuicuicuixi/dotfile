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
# 代理地址由 flake.nix 统一管理，通过 $MY_PROXY_ADDR 注入（nix 环境），
# 非 nix 环境下使用默认值。
_PROXY_ADDR="${MY_PROXY_ADDR:-}"

on_proxy() {
    if [ -z "$_PROXY_ADDR" ]; then
        echo -e "\033[31m未配置代理端口，请在 local.nix 中设置 proxyPort\033[0m"
        return 1
    fi
    export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
    export http_proxy="$_PROXY_ADDR"
    export https_proxy=$http_proxy
    export all_proxy="socks5://${_PROXY_ADDR##*://}"
    echo -e "\n"
    echo -e "\033[32m代理已开启\033[0m"
}

off_proxy() {
    unset http_proxy
    unset https_proxy
    unset all_proxy
    echo -e "\033[31m代理已关闭\033[0m"
}

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
