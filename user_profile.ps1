# Load prompt config
Invoke-Expression (&starship init powershell)
$ENV:STARSHIP_DISTRO = "者"
$ENV:STARSHIP_CONFIG = "D:\.dotfile\.config\starship.toml"

# Icons
Import-Module -Name Terminal-Icons

# PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History

# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# $env:HTTP_PROXY="http://127.0.0.1:10809"
# $env:HTTPS_PROXY="https://127.0.0.1:10809"
#
# git config --global http.proxy "http://127.0.0.1:10809"
# git config --global https.proxy "https://127.0.0.1:10809"

# Alias
Set-Alias vim nvim
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'

# Utilities
function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
      Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
