-- Python：Nix 管理工具 + LazyVim extra 管理配置
-- ================================================
-- LazyVim extras.lang.python 已提供：LSP（pyright/ruff）、DAP（debugpy）、
-- venv 选择器、neotest。此处仅覆写 mason = false 让 Mason 使用 Nix 二进制，
-- 并补充 extra 未覆盖的 conform（formatter）和 nvim-lint（linter）。

return {
  -- 告诉 Mason：以下 LSP 由 Nix 提供，不要下载
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = { mason = false },
        basedpyright = { mason = false },
        ruff = { mason = false },
      },
    },
  },

  -- Formatter：ruff format（仅手动调用，vim.g.autoformat = false）
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
      },
    },
  },

  -- Linter：ruff check
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        python = { "ruff" },
      },
    },
  },
}
