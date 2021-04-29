local M = {}


-- Yank
vim.cmd [[command! Cp :%yank +]]

-- Session
vim.cmd [[command! Ms :mksession! .session.vim]]
vim.cmd [[command! Rs :source .session.vim]]


return M
