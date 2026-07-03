# SSH 客户端 — 所有机器统一配置
# ================================
# 使用 home-manager 新版 `settings` API（替代已废弃的 top-level 选项）。
# `settings."*"` 为全局默认，对所有 Host 生效。
# matchBlocks（具体连哪台机器、用哪把 key）每台不同，后续按需添加。
#
# 常用转发：
#   动态转发: ssh -D 1080 <host>               # SOCKS5 代理
#   本地转发: ssh -L 8080:localhost:3000 <host>  # 本机 8080 → 远端 3000
#   远程转发: ssh -R 9090:localhost:4000 <host>  # 远端 9090 → 本机 4000

{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false; # 不使用 home-manager 即将废弃的内置默认值

    settings = {
      # ---- 全局默认（所有 Host 生效，与当前 macOS 行为一致） ----
      "*" = {
        ForwardAgent = "no";
        ForwardX11 = "no";
        ForwardX11Trusted = "no";

        # 后续可开启的优化：
        # 传输压缩（日志/文本压缩率高，慢网络建议开启）
        # Compression = "yes";
        #
        # 心跳保活（防 NAT/防火墙断连，建议 60s）
        # ServerAliveInterval = "60";
        # ServerAliveCountMax = "3";
        #
        # 哈希 known_hosts（主机名泄露也不暴露拓扑）
        # HashKnownHosts = "yes";
        #
        # 新主机自动接受指纹（防 MITM，推荐）
        # StrictHostKeyChecking = "accept-new";
        #
        # 连接超时
        # ConnectTimeout = "10";
        #
        # TCP 连接复用（同一 Host 秒连，推荐）
        # ControlMaster = "auto";
        # ControlPath = "~/.ssh/control-%r@%h:%p";
        # ControlPersist = "10m";
      };
    };
  };
}
