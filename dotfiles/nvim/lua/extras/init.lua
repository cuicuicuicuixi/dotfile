-- LazyVim extras 集中管理
-- ==========================
-- 所有启用的 LazyVim 内置 extra 在此统一导入，不走 nix 硬编码 spec。
-- 新增 extra 时只需在此加一行 import，执行 just switch 后生效。

return {
  -- lang
  { "LazyVim/LazyVim", import = "lazyvim.plugins.extras.lang.python" },
  { "LazyVim/LazyVim", import = "lazyvim.plugins.extras.lang.nix" },
  { "LazyVim/LazyVim", import = "lazyvim.plugins.extras.lang.rust" },
  { "LazyVim/LazyVim", import = "lazyvim.plugins.extras.lang.markdown" },
  { "LazyVim/LazyVim", import = "lazyvim.plugins.extras.lang.json" },
  { "LazyVim/LazyVim", import = "lazyvim.plugins.extras.lang.yaml" },
  { "LazyVim/LazyVim", import = "lazyvim.plugins.extras.lang.toml" },
  { "LazyVim/LazyVim", import = "lazyvim.plugins.extras.lang.typescript" },
  { "LazyVim/LazyVim", import = "lazyvim.plugins.extras.lang.docker" },

  -- editor
  { "LazyVim/LazyVim", import = "lazyvim.plugins.extras.editor.aerial" },

  -- ui
  { "LazyVim/LazyVim", import = "lazyvim.plugins.extras.ui.treesitter-context" },
}
