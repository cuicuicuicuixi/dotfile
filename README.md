# 🧊 Nix Flake 多系统配置

基于 Nix Flakes 的 macOS / NixOS / Linux 统一开发环境配置。

## ✨ 特性

- **多平台支持** — macOS（nix-darwin）、NixOS、其他 Linux（home-manager）统一管理
- **声明式配置** — 所有系统设置、应用包、dotfiles 均以 Nix 声明
- **模块化架构** — 系统管理 / 用户环境 / Shell 组件分层清晰
- **一键安装** — `install.sh` 自动检测系统类型，生成本地配置并完成首次构建

## 📁 目录结构

```
.
├── flake.nix                 # Flake 入口（定义 darwinConfigurations / nixosConfigurations / homeConfigurations）
├── flake.lock                # 依赖版本锁定
├── install.sh                # 一键安装/初始化脚本
├── update_nix.sh             # 更新 nix-channel 脚本
├── check_defaults.sh         # macOS 系统配置检查脚本
├── dotfiles/                 # 手动管理的配置文件
│   ├── wezterm.lua           # WezTerm 终端配置
│   ├── zshrc.sh              # Zsh 初始化脚本
│   ├── shellrc.sh            # 通用 Shell 初始化
│   ├── fastfetch/            # Fastfetch 系统信息展示
│   └── nvim/                 # Neovim 配置（LazyVim）
└── modules/
    ├── darwin/               # macOS 系统级配置（nix-darwin）
    │   ├── default.nix       # 入口（导入 system + homebrew + home-manager 集成）
    │   ├── system.nix        # macOS 系统设置
    │   └── homebrew.nix      # Homebrew 管理
    ├── nixos/                # NixOS 系统级配置
    │   ├── default.nix       # 入口
    │   └── system.nix        # NixOS 系统设置
    └── home/                 # 跨平台用户环境配置（home-manager）
        ├── default.nix       # 入口
        ├── local.nix         # 本地个人信息（Git 用户名/邮箱等，不推送）
        ├── packages.nix      # 命令行工具包
        ├── env.nix           # 环境变量
        ├── fonts.nix         # 字体配置
        ├── git.nix           # Git 配置
        ├── shell.nix         # Shell 入口（Zsh/Bash + 公共工具）
        └── shell/            # Shell 子模块
            ├── zsh.nix       # Zsh 配置
            ├── bash.nix      # Bash 配置（Linux 后备）
            ├── starship.nix  # Starship 提示符
            ├── tmux.nix      # Tmux 配置
            ├── ghostty.nix   # Ghostty 终端配置
            ├── lazyvim.nix   # LazyVim 集成
            └── aliases.nix   # 命令别名
```

## 🚀 快速开始

### 安装

```bash
# 克隆仓库
git clone https://github.com/cuicuicuicuixi/dotfile.git ~/.config/nix
cd ~/.config/nix
git checkout nix-flake

# 运行安装脚本（自动检测系统类型并构建）
./install.sh
```

### 日常使用

#### macOS

```bash
sudo darwin-rebuild switch --flake ~/.config/nix#MacBook-Pro --impure
```

#### NixOS

```bash
# x86_64
sudo nixos-rebuild switch --flake ~/.config/nix#nixos-x86 --impure
# aarch64
sudo nixos-rebuild switch --flake ~/.config/nix#nixos-arm --impure
```

#### 其他 Linux（独立 home-manager）

```bash
home-manager switch --flake ~/.config/nix#<用户名>@linux-x86 --impure
```

## 🛠 主要组件

| 类别 | 工具 |
|------|------|
| **Shell** | Zsh / Bash + Starship + Zoxide + Fzf |
| **终端** | WezTerm / Ghostty |
| **编辑器** | Neovim (LazyVim via nixvim) |
| **Git** | Git + LazyGit + Delta (diff 美化) |
| **工作流** | Tmux + Direnv + Just |
| **语言** | Rust (rustc + cargo)、Node.js (fnm) |
| **AI** | Claude Code |
| **字体** | 多字体配置（见 `modules/home/fonts.nix`） |
| **工具** | htop/btop、ripgrep/fd/bat/eza、difftastic、typst 等 |

## ⚙️ 本地配置

首次运行 `install.sh` 时会提示输入 Git 用户名、邮箱等信息，自动生成 `modules/home/local.nix`。

该文件包含个人敏感信息，已通过 `.gitignore` 排除，不会推送到远程仓库。

如需手动创建：

```nix
{
  gitUserName = "Your Name";
  gitUserEmail = "your.email@example.com";
  primaryUser = "your-username";
}
```

## 📝 参考

- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [nix-darwin](https://github.com/LnL7/nix-darwin)
- [home-manager](https://github.com/nix-community/home-manager)
- [nixvim](https://github.com/nix-community/nixvim)
