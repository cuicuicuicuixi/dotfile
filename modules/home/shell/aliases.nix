# 共享 shell 别名（zsh 和 bash 共用）
# =====================================
# 此文件不是模块，只是一个 attrset，被 zsh.nix 和 bash.nix 导入。
{
  # ls 系列
  ls = "eza --icons --group-directories-first";
  ll = "eza --icons --group-directories-first -hl";
  exa = "eza";
  l = "ls -la";
  # 编辑
  vim = "nvim";
  nvimrc = "nvim ~/.config/nvim/";
  # git
  g = "lazygit";
  m = "git checkout master";
  s = "git checkout stable";
  # grep
  grep = "grep --color";
  egrep = "egrep --color=auto";
  fgrep = "fgrep --color=auto";
  # 安全
  cp = "cp -i";
  mv = "mv -i";
  rm = "rm -i";
  # 磁盘
  df = "df -h";
  free = "free -m";
  # 进程
  psmem = "ps auxf | sort -nr -k 4 | head -5";
  pscpu = "ps auxf | sort -nr -k 3 | head -5";
  # 杂项
  neofetch = "fastfetch";
}
