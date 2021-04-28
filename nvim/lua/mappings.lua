local api = vim.api

local leader = [[\<Space>]]
vim.g.mapleader = leader

api.nvim_set_keymap("n", "Y", "y$", { noremap = true })

api.nvim_set_keymap("c", "<C-p>", "<Up>", { noremap = true })
api.nvim_set_keymap("c", "<C-n>", "<Down>", { noremap = true })
