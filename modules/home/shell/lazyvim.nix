# LazyVim via nixvim — nix 管理 neovim/lazy/LazyVim，runtime 下载插件
{
  self,
  inputs,
  pkgs,
  ...
}:
let
  nvimPkg = inputs.nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvimWithModule {
    module = {
      extraPackages = with pkgs; [
        tree-sitter
        gcc
        nodejs
        # ---- Python LSP / Formatter / Linter / Debugger（Nix 管理，Mason 直接使用）----
        pyright
        basedpyright
        ruff
        python3Packages.debugpy
      ];
      # 用 extraPlugins 把 lazy-nvim 和 LazyVim 加入 rtp（不走 git clone）
      extraPlugins = with pkgs.vimPlugins; [
        lazy-nvim
        LazyVim
        snacks-nvim # 从 nix 装，版本匹配 LazyVim，避免时序问题
      ];

      extraConfigLuaPre = ''
        vim.g.autoformat = false
        -- 预加载 LazyVim util，确保 snacks 初始化时 LazyVim.lsp.code_actions 可用
        _G.LazyVim = require("lazyvim.util")
        require("lazyvim.util.lsp")
      '';

      extraConfigLua = ''
        require("lazy").setup({
          spec = {
            { "LazyVim/LazyVim", import = "lazyvim.plugins" },
            { import = "extras" }, -- LazyVim extras，必须在 plugins 之前
            { import = "plugins" }, -- 用户自定义插件，可覆写 extras
          },
          defaults = {
            lazy = false,
            version = false,
          },
          install = { colorscheme = { "tokyonight", "habamax" } },
          checker = { enabled = true, notify = false },
          performance = {
            rtp = {
              -- tohtml / tutor / zipPlugin 已由 LazyVim 默认禁用
              disabled_plugins = { "gzip", "tarPlugin" },
            },
          },
        })
      '';
    };
  };
in
{
  home.packages = [ nvimPkg ];

  # LazyVim 自定义 lua 配置从 dotfiles 加载
  xdg.configFile."nvim/lua" = {
    source = "${self}/dotfiles/nvim/lua";
    recursive = true;
  };
}
