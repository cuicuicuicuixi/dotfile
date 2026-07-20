# 代理函数 — 由 zsh.nix 和 bash.nix 共享
# 生成 on_proxy / off_proxy shell 函数代码
proxyAddr: let
  onProxy =
    if proxyAddr != null then ''
      on_proxy() {
          export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
          export http_proxy="${proxyAddr}"
          export https_proxy=$http_proxy
          export all_proxy="socks5://${builtins.replaceStrings [ "http://" ] [ "" ] proxyAddr}"
          echo -e "\033[32m代理已开启\033[0m"
      }
    '' else ''
      on_proxy() {
          echo -e "\033[31m未配置代理，请运行 just config 设置 proxyHost 和 proxyPort\033[0m"
          return 1
      }
    '';
  offProxy = ''
    off_proxy() {
        unset http_proxy
        unset https_proxy
        unset all_proxy
        echo -e "\033[31m代理已关闭\033[0m"
    }
  '';
in onProxy + offProxy
