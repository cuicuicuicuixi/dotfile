# ==========================================================
# Nix Flake 构建命令
# ==========================================================
# 用法：
#   just install     首次安装（安装 Nix + 配置 + 构建）
#   just config      重新填写本地配置（local.nix）
#   just             默认：检测系统并执行 rebuild
#   just switch -m   使用国内镜像加速
#   just props       查看系统配置属性
#   just verify       验证 flake 配置（构建前建议先跑）
#   just update      更新 flake.lock
#   just clean       清理构建缓存
# ==========================================================

flake_dir := "$HOME/.config/nix"
connect_timeout := "360"

# 默认：检测系统并重建
default: switch

# ---- 首次安装 ----
install:
    bash {{flake_dir}}/scripts/bootstrap.sh

# ---- 本地配置 ----
config:
    bash {{flake_dir}}/scripts/config.sh {{flake_dir}}

# ---- 系统属性 ----
props:
    bash {{flake_dir}}/scripts/props.sh

# ---- 配置验证 ----
verify:
    @echo "==> 验证 flake 配置..."
    cd {{flake_dir}} && nix flake check
    @echo "==> 验证通过"

# ---- 重建 ----
switch mirror="":
    @FLAKE_DIR={{flake_dir}} CONNECT_TIMEOUT={{connect_timeout}} USE_MIRROR={{if mirror != "" { "true" } else { "false" }}} bash {{flake_dir}}/scripts/switch.sh

# ---- 更新依赖 ----
update:
    @echo "==> 更新 flake.lock..."
    cd {{flake_dir}} && nix flake update
    @echo "==> 完成。如 lock 文件有变更请提交："
    @echo "    git add flake.lock && git commit -m 'chore: flake update'"

# ---- 清理 ----
clean:
    @echo "==> 清理 nix store..."
    nix-collect-garbage -d
    @echo "==> 清理 home-manager 旧世代..."
    home-manager expire-generations "-7 days" 2>/dev/null || true
    @echo "==> 完成"
