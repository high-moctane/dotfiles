local M = {}


M.config = function()
    local api = vim.api

    api.nvim_set_keymap("x", "<Leader>g", "<Plug>(EasyAlign)", {})
    api.nvim_set_keymap("n", "<Leader>g", "<Plug>(EasyAlign)", {})
end


return M
