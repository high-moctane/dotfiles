local M = {}


-- Yank
vim.cmd [[command! Cp :%yank +]]

-- Session
vim.cmd [[command! Ms :mksession! .session.vim]]
vim.cmd [[command! Rs :source .session.vim]]

vim.cmd [[command! InstallPacker :lua require"plug_configs/packer".install()]]

vim.cmd [[command! SyncSKK :lua require"plug_configs/eskk".sync_skk_dictionary()]]


return M
