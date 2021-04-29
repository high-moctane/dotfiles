local M = {}


M.config = function()
    vim.api.nvim_set_keymap(
        "i", "<C-l>", "<cmd>lua return require'snippets'.expand_or_advance(1)<CR>",
        { noremap = true }
    )
    vim.api.nvim_set_keymap(
        "i", "<C-h>", "<cmd>lua return require'snippets'.expand_or_advance(-1)<CR>",
        { noremap = true }
    )
end

return M
