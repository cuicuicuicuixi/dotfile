# ==========================================================
# Nix Flake 构建命令
# ==========================================================
# 用法：
#   just install     首次安装（安装 Nix + 配置 + 构建）
#   just config      重新填写本地配置（local.nix）
#   just             默认：检测系统并执行 rebuild
#   just switch -m   使用国内镜像加速
#   just update      更新 flake.lock
#   just clean       清理构建缓存
# ==========================================================

flake_dir := "$HOME/.config/nix"
connect_timeout := "360"

# 国内镜像源（清华 + 上交 + 中科大 + 官方兜底）
mirror_substituters := "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://mirror.sjtu.edu.cn/nix-channels/store https://mirrors.ustc.edu.cn/nix-channels/store https://cache.nixos.org"

# 检测系统架构
arch := `uname -m`
os := `uname -s`

# 默认：检测系统并重建
default: switch

# ---- 首次安装 ----
install:
    @echo "================================================"
    @echo "  Nix 配置安装"
    @echo "================================================"
    @echo ""
    # 1. 安装 Nix
    @if ! command -v nix &>/dev/null; then \
        echo "==> 未检测到 Nix，正在安装..."; \
        sh <(curl -L https://nixos.org/nix/install) --daemon; \
        if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then \
            . "$HOME/.nix-profile/etc/profile.d/nix.sh"; \
        fi; \
        echo "==> Nix 安装完成"; \
    else \
        echo "==> Nix 已安装: $(nix --version)"; \
    fi
    # 2. 创建 local.nix
    @if [ ! -f "{{flake_dir}}/modules/home/local.nix" ]; then \
        echo ""; \
        just config; \
    else \
        echo "==> local.nix 已存在，跳过"; \
    fi
    # 3. 首次构建
    @echo ""
    @echo "==> 开始首次构建..."
    @just switch

# ---- 本地配置 ----
config:
    @echo "================================================"
    @echo "  配置本地信息（local.nix）"
    @echo "================================================"
    @echo ""
    @read -p "  Git 用户名: " GIT_NAME; \
    read -p "  Git 邮箱: " GIT_EMAIL; \
    read -p "  主用户名 [$(whoami)]: " PRIMARY_USER; \
    PRIMARY_USER="$${PRIMARY_USER:-$(whoami)}"; \
    printf '# 本地个人信息（不要提交到 git！）\n{\n  gitUserName = "%s";\n  gitUserEmail = "%s";\n  primaryUser = "%s";\n}\n' "$$GIT_NAME" "$$GIT_EMAIL" "$$PRIMARY_USER" > "{{flake_dir}}/modules/home/local.nix"
    @echo ""
    @echo "==> 配置已写入 modules/home/local.nix"

# ---- 重建 ----
switch mirror="":
    @echo "==> 系统: {{os}} ({{arch}})"
    @if [ "{{os}}" = "Darwin" ]; then \
        echo "==> macOS: darwin-rebuild"; \
        sudo darwin-rebuild switch --flake {{flake_dir}}#MacBook-Pro --impure --option connect-timeout {{connect_timeout}} {{if mirror != "" { "--option substituters \"" + mirror_substituters + "\"" } else { "" }}}; \
    elif [ -f /etc/NIXOS ] || grep -q NixOS /etc/os-release 2>/dev/null; then \
        HOST=$(if [ "{{arch}}" = "x86_64" ]; then echo "nixos-x86"; else echo "nixos-arm"; fi); \
        echo "==> NixOS: nixos-rebuild ($HOST)"; \
        sudo nixos-rebuild switch --flake {{flake_dir}}#$HOST --impure --option connect-timeout {{connect_timeout}} {{if mirror != "" { "--option substituters \"" + mirror_substituters + "\"" } else { "" }}}; \
    else \
        HOST="$(whoami)@$(if [ "{{arch}}" = "x86_64" ]; then echo "linux-x86"; else echo "linux-arm"; fi)"; \
        echo "==> Linux: home-manager ($HOST)"; \
        home-manager switch --flake {{flake_dir}}#$HOST --impure --option connect-timeout {{connect_timeout}} {{if mirror != "" { "--option substituters \"" + mirror_substituters + "\"" } else { "" }}}; \
    fi

# ---- 更新依赖 ----
update:
    @echo "==> 更新 flake.lock..."
    cd {{flake_dir}} && nix flake update
    @echo "==> 完成，请检查变更后 commit"

# ---- 清理 ----
clean:
    @echo "==> 清理 nix store..."
    nix-collect-garbage -d
    @echo "==> 清理 home-manager 旧世代..."
    home-manager expire-generations "-7 days" 2>/dev/null || true
    @echo "==> 完成"
