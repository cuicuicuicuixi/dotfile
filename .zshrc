#!/bin/sh
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"


# history
HISTFILE=~/.zsh_history

# source
plug "$HOME/.config/zsh/aliases.zsh"
plug "$HOME/.config/zsh/exports.zsh"

# plugins
plug "zsh-users/zsh-history-substring-search"
plug "esc/conda-zsh-completion"
plug "zsh-users/zsh-autosuggestions"
plug "hlissner/zsh-autopair"
plug "zap-zsh/supercharge"
plug "zap-zsh/vim"
plug "zap-zsh/zap-prompt"
plug "zap-zsh/fzf"
plug "zap-zsh/exa"
plug "zsh-users/zsh-syntax-highlighting"

# keybinds
bindkey '^ ' autosuggest-accept
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

export PATH="$HOME/.local/bin":$PATH
export PULSE_SCRIPT=/etc/xrdp/pulse/default.pa

if command -v bat &> /dev/null; then
  alias cat="bat -pp --theme \"Visual Studio Dark+\"" 
  alias catt="bat --theme \"Visual Studio Dark+\"" 
fi

# [[ -s /home/zwf/.autojump/etc/profile.d/autojump.sh ]] && source /home/zwf/.autojump/etc/profile.d/autojump.sh

# Colormap
function colormap() {
  for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}


# ALIAS COMMANDS
alias ls="exa --icons --group-directories-first"
alias ll="exa --icons --group-directories-first -l"
alias l="ls -la"
alias g="goto"
alias grep='grep --color'


# find out which distribution we are running on
LFILE="/etc/os-release"
MFILE="/System/Library/CoreServices/SystemVersion.plist"
if [[ -f $LFILE ]]; then
  _distro=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
elif [[ -f $MFILE ]]; then
  _distro="macos"
fi

# set an icon based on the distro
# make sure your font is compatible with https://github.com/lukas-w/font-logos
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
    *macos*)                 ICON=" ";;
    *)                       ICON=" ";;
esac

export STARSHIP_DISTRO="$ICON"

# eval "$(starship init zsh)"
