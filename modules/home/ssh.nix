# SSH 客户端 — 所有机器统一配置
# ================================
# 当前与 macOS 默认行为完全一致，后续逐步开启优化选项。
# matchBlocks（具体连哪台机器、用哪把 key）每台不同，不放这里。
#
# 常用转发：
#   动态转发: ssh -D 1080 <host>               # SOCKS5 代理
#   本地转发: ssh -L 8080:localhost:3000 <host>  # 本机 8080 → 远端 3000
#   远程转发: ssh -R 9090:localhost:4000 <host>  # 远端 9090 → 本机 4000

{ ... }:
{
  programs.ssh = {
    enable = true;

    # ---- 当前默认行为（后续按需开启） ----

    # 传输压缩（对日志/文本压缩率高，慢网络下建议开启）
    # compression = true;

    # 心跳保活（防止 NAT/防火墙断连，建议 60s）
    # serverAliveInterval = 60;
    # serverAliveCountMax = 3;

    # 哈希 known_hosts（泄露主机名也不暴露拓扑）
    # hashKnownHosts = true;

    # ---- 显式声明的默认值（防止系统级 ssh_config 覆盖） ----
    forwardAgent = false;

    extraOptionOverrides = {
      ForwardAgent = "no";
      ForwardX11 = "no";
      ForwardX11Trusted = "no";

      # 后续可开启的优化：
      # 新主机自动接受指纹（防 MITM，推荐）
      # StrictHostKeyChecking = "accept-new";
      #
      # 连接超时
      # ConnectTimeout = 10;
      #
      # TCP 连接复用（同一 Host 秒连，推荐）
      # ControlMaster = "auto";
      # ControlPath = "~/.ssh/control-%r@%h:%p";
      # ControlPersist = "10m";
    };
  };
}
