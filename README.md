# 🧊 Nix Flake 多系统配置

基于 Nix Flakes 的 macOS / NixOS / Linux 统一开发环境配置。

## ✨ 特性

- **多平台支持** — macOS（nix-darwin）、NixOS、其他 Linux（home-manager）统一管理
- **声明式配置** — 所有系统设置、应用包、dotfiles 均以 Nix 声明
- **模块化架构** — 系统管理 / 用户环境 / Shell 组件分层清晰
- **一键安装** — `just install` 自动检测系统类型，生成本地配置并完成首次构建

## 📁 目录结构

```
.
├── flake.nix                 # Flake 入口（定义 darwinConfigurations / nixosConfigurations / homeConfigurations）
├── flake.lock                # 依赖版本锁定
├── justfile                   # Just 命令（安装 / 配置 / 重建 / 属性 / 更新 / 清理）
├── scripts/
│   ├── config.sh             # 本地配置交互脚本（just config）
│   ├── switch.sh             # 系统重建脚本（just switch）
│   └── props.sh              # 系统属性查看脚本（just props）
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
        ├── local.nix         # 本地个人信息（通过 just config 填写）
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

# 一键安装（自动安装 Nix、生成本地配置、首次构建）
just install
```

### 日常使用

```bash
just              # 重建系统（自动检测平台）
just config       # 重新填写本地配置（Git 用户名/邮箱等）
just switch -m    # 使用国内镜像加速
just update       # 更新 flake.lock 依赖
just clean        # 清理 nix store 和旧世代
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

仓库中 `modules/home/local.nix` 是占位文件。首次使用时运行：

```bash
just config
```

按提示输入 Git 用户名、邮箱和系统用户名，会自动写入 `local.nix`。

## 📝 参考

- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [nix-darwin](https://github.com/LnL7/nix-darwin)
- [home-manager](https://github.com/nix-community/home-manager)
- [nixvim](https://github.com/nix-community/nixvim)
