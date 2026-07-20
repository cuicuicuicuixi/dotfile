# 🧊 Nix Flake 多系统配置

基于 Nix Flakes 的 macOS / NixOS / Linux 统一开发环境配置。

## ✨ 特性

- **多平台支持** — macOS（nix-darwin）、NixOS、其他 Linux（home-manager）统一管理
- **声明式配置** — 所有系统设置、应用包、dotfiles 均以 Nix 声明
- **模块化架构** — 系统管理 / 用户环境 / Shell 组件分层清晰
- **一键安装** — `bash bootstrap.sh` 从零开始：安装 Nix → 生成本地配置 → 完成首次构建

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
├── hosts/                    # NixOS 主机级配置
│   ├── nixos-x86/            # x86_64 主机入口及硬件配置
│   └── nixos-arm/            # aarch64 主机入口及硬件配置
├── templates/                # 项目开发环境模板
│   ├── python/               # 普通 Python（Linux + macOS）
│   └── python-rocm/          # ROCm Python（x86_64 Linux）
└── modules/
    ├── darwin/               # macOS 系统级配置（nix-darwin）
    │   ├── default.nix       # 入口（导入 system + homebrew + home-manager 集成）
    │   ├── system.nix        # macOS 系统设置
    │   └── homebrew.nix      # Homebrew 管理
    ├── nixos/                # NixOS 系统级配置
    │   ├── default.nix       # 入口
    │   └── system.nix        # NixOS 系统设置
    ├── dev/                  # 跨平台开发环境配置
    │   ├── default.nix       # 开发模块入口
    │   ├── direnv.nix        # direnv + nix-direnv 集成
    │   ├── packages.nix      # 通用开发与构建工具
    │   └── python.nix        # Python 环境入口（uv）
    └── home/                 # 跨平台用户环境配置（home-manager）
        ├── default.nix       # 入口
        ├── local.example.nix # 无个人信息的安全默认配置
        ├── packages.nix      # 命令行工具包
        ├── env.nix           # 环境变量
        ├── fonts.nix         # 字体配置
        ├── git.nix           # Git 配置 + 全局 gitignore
        ├── ssh.nix           # SSH 客户端（多服务器统一配置）
        ├── shell.nix         # Shell 入口（Zsh/Bash + 公共工具）
        └── shell/            # Shell 子模块
            ├── zsh.nix       # Zsh 配置
            ├── bash.nix      # Bash 配置（Linux 后备）
            ├── starship.nix  # Starship 提示符
            ├── tmux.nix      # Tmux 配置
            ├── kitty.nix     # Kitty 终端配置
            ├── ghostty.nix   # Ghostty 终端配置
            ├── lazyvim.nix   # LazyVim 集成
            └── aliases.nix   # 命令别名
```

## 🚀 快速开始

### 首次安装

```bash
git clone https://github.com/cuicuicuicuixi/dotfile.git ~/.config/nix && \
  bash ~/.config/nix/scripts/bootstrap.sh
```

`bootstrap.sh` 会自动处理：下载 Nix 安装器（如未安装）→ 生成仓库外本机配置 → 首次构建。安装器不会直接执行网络响应，而是先保存到临时文件；建议通过可信渠道取得摘要并设置 `NIX_INSTALLER_SHA256`。未提供摘要时脚本会显示下载文件摘要并要求人工确认，但这不等同于来源校验。

普通 Linux 在 `home-manager` CLI 尚不可用时会复用仓库 `flake.lock` 中锁定的输入启动，不会单独解析 `home-manager/master`；首次激活会把 CLI 安装到用户环境，后续重建可直接调用。请确保克隆结果包含 `flake.lock`，以避免 GitHub API 匿名请求限流。

普通 Linux 每次执行独立 Home Manager 切换时，都会将未托管的冲突文件备份为 `<原文件>.backup`（例如从 Zsh 切换到 Bash 时生成 `~/.bashrc.backup`），然后再接管目标文件。已由 Home Manager 管理的文件不会重复备份；如果同名备份已存在且目标文件再次发生冲突，请先检查并重命名旧备份。可通过 `HOME_MANAGER_BACKUP_EXTENSION` 自定义备份后缀。

构建完成后 `just` 由 nix 接管安装（`modules/dev/packages.nix`），之后直接用 `just` 即可。NixOS 用户首次使用前，必须用目标机器生成的真实配置替换 `hosts/<hostname>/hardware-configuration.nix`，检查无误后再把同目录的 `enabled.nix` 改为 `true`；未启用的主机不会出现在 Flake 输出中。

> **⚠️ Homebrew 用户注意**：如果你已通过 `brew install` 安装了大量 CLI 工具，**首次构建前** 请将 `modules/darwin/homebrew.nix` 中的 `cleanup` 改为 `"none"` 或 `"check"`，否则 `cleanup = "uninstall"` 会卸载所有未被 nix 声明的 brew formula/cask。确认预期效果后再改回 `"uninstall"`。

### 日常使用

```bash
just              # 重建系统（自动检测平台）
just config       # 重新填写本地配置（Git 用户名/邮箱/代理地址和端口等）
just switch -m    # 使用国内镜像加速
just update       # 更新 flake.lock 依赖
just clean        # 清理 nix store 和旧世代
```

### Python 项目模板

普通 Python 3.12 项目支持 Linux 和 macOS：

```bash
mkdir my-project && cd my-project
nix flake init -t "$HOME/.config/nix#python"
direnv allow
uv sync
```

ROCm 项目仅支持 x86_64 Linux，并复用宿主机的 `/opt/rocm`：

```bash
mkdir my-rocm-project && cd my-rocm-project
nix flake init -t "$HOME/.config/nix#python-rocm"
cp .envrc.local.example .envrc.local
# 按本机 ROCm 路径和 GPU 架构编辑 .envrc.local
direnv allow
uv sync
```

两套模板均由 Nix 固定 Python 3.12 和通用工具，uv 管理 `.venv` 与 Python 依赖。项目创建后应修改 `pyproject.toml` 中的占位项目名，并提交生成的 `flake.lock` 和 `uv.lock`；`.venv`、`.direnv` 及 ROCm 主机私有配置不会进入 Git。

## 🛠 主要组件

| 类别 | 工具 |
|------|------|
| **Shell** | Zsh / Bash + Starship + Zoxide + Fzf |
| **终端** | WezTerm / Ghostty |
| **编辑器** | Neovim (LazyVim via nixvim)，EDITOR/VISUAL 统一设为 nvim |
| **Git** | Git + LazyGit + Delta (diff 美化) + 全局 gitignore |
| **SSH** | 多服务器统一客户端配置（settings API） |
| **工作流** | Tmux + Direnv + Nix Direnv + Just + bat-extras (batman/batdiff/batgrep) |
| **语言** | Rust (rustc + cargo)、Node.js (fnm)、Python (uv；运行时由项目配置) |
| **AI** | Claude Code |
| **代理** | 本地代理地址和端口可配置（`just config`），nix-daemon / shell 环境按需注入 |
| **字体** | 多字体配置（见 `modules/home/fonts.nix`） |
| **系统** | nix gc 自动清理 7 天前旧世代 |
| **工具** | htop/btop、ripgrep/fd/bat/eza、difftastic、typst 等 |

## ⚙️ 本地配置

仓库只保留不含个人信息的 `modules/home/local.example.nix`。首次使用时运行：

```bash
just config
```

按提示输入 Git 用户名、邮箱、系统用户名以及 HTTP 代理地址和端口；代理地址支持 IPv4 或域名，默认为 `127.0.0.1`。短主机名和 Nix 系统平台会自动检测。macOS 固定管理 Zsh；Linux 会检测目标用户的登录 Shell，识别到 Bash 时管理 `.bashrc`、`.bash_profile` 和 `.profile`，识别到 Zsh 时管理 Zsh 配置，无法识别则默认 Zsh。配置默认写入 `$XDG_CONFIG_HOME/nix-local/local.nix`（未设置 `XDG_CONFIG_HOME` 时为 `~/.config/nix-local/local.nix`），权限为 `0600`，不会进入 Flake 仓库。可通过 `NIX_LOCAL_CONFIG` 覆盖配置路径，通过 `NIX_HOSTNAME` 覆盖检测到的短主机名。非 NixOS Home Manager 输出名称为 `<用户>@<主机名>`。

代理端口留空表示不使用代理，nix-daemon 将不会注入代理环境变量。`on_proxy` / `off_proxy` 函数可动态开关终端代理。旧配置未包含 `proxyHost` 时仍默认使用 `127.0.0.1`。

### Flake 输出命名

Flake 属性名本身是任意选择器，并不强制等于 hostname。为便于 `rebuild` 自动选择和多机管理，本项目统一采用以下约定：

- `darwinConfigurations.<hostname>`
- `nixosConfigurations.<hostname>`
- `homeConfigurations."<user>@<hostname>"`

`hostname` 来自本机私有配置，并由 `scripts/config.sh` 使用 `hostname -s` 自动生成。NixOS 的 `nixos-x86` / `nixos-arm` 目录只表示硬件配置模板，不再作为 Flake 输出名称。

## 📝 参考

- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [nix-darwin](https://github.com/LnL7/nix-darwin)
- [home-manager](https://github.com/nix-community/home-manager)
- [nixvim](https://github.com/nix-community/nixvim)
