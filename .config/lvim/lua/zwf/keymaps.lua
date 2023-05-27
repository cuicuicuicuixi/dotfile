local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<Space>hh", "<cmd>split<CR>", opts)
vim.keymap.set("n", "<Space>v", "<cmd>vsplit<CR>", opts)
vim.keymap.set("n", "<s-h>", "<Plug>(CybuPrev)", opts)
vim.keymap.set("n", "<s-l>", "<Plug>(CybuNext)", opts)


lvim.builtin.which_key.mappings["S"] = {
  name = "Session",
  c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
  l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
  Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}
