local M = {}


M.run = function()
    vim.cmd "TSUpdate"
    vim.cmd "TSInstall maintained"
end


M.config = function()
    require'nvim-treesitter.configs'.setup {
        highlight = {
            enable = true,
        },
        incremental_selection = {
            enable = true,
        },
        indent = {
            enable = true,
            disable = { "python" },
        },
    }

    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
end


return M
