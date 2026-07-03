# 以下插件已由 programs.zsh.plugins 管理（shell.nix）：
#   zsh-autosuggestions, zsh-syntax-highlighting, zsh-history-substring-search, zsh-autopair
# 以下已废弃（zap 专属，功能已有替代）：
#   supercharge, vim, zap-prompt, exa, conda-zsh-completion
#
# fzf 集成由 programs.fzf 管理（shell.nix）

# --- keybinds ---
bindkey '^ ' autosuggest-accept
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# --- bat 别名 ---
# bat 配置由 programs.bat 管理（shell.nix），保留手动 fallback
if command -v bat &> /dev/null; then
  alias cat="bat -pp"
fi

# --- Colormap ---
function colormap() {
  for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}

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
function on_proxy() {
    export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
    export http_proxy="http://127.0.0.1:7890"
    export https_proxy=$http_proxy
    export all_proxy=socks5://127.0.0.1:7890
    echo -e "\n"
    echo -e "\033[32m代理已开启\033[0m"
}

function off_proxy(){
    unset http_proxy
    unset https_proxy
    unset all_proxy
    echo -e "\033[31m代理已关闭\033[0m"
}

# --- conda（由 homebrew miniconda cask 提供） ---
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup

# --- fastfetch ---
if command -v fastfetch >/dev/null 2>&1; then
    fastfetch --config "$HOME/.config/fastfetch/startup.jsonc"
fi
