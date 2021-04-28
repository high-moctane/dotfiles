local M = {}


M.config = function()
    local api = vim.api

    api.nvim_set_keymap(
        "i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]],
        { expr = true, noremap = true }
    )
    api.nvim_set_keymap(
        "i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<Tab>"]],
        { expr = true, noremap = true }
    )

    vim.g.completion_enable_snippet = "snippets.nvim"

    vim.g.completion_confirm_key = ""
    api.nvim_set_keymap(
        "i", "<cr>", [[pumvisible() ? complete_info()["selected"] != "-1" ? "\<Plug>(completion_confirm_completion)"  : "\<c-e>\<CR>" : "\<CR>"]],
        { expr = true }
    )

    vim.g.completion_matching_smart_case = 1

    vim.g.completion_chain_complete_list = {
        default = {
            { complete_items = {
                "lsp", "snippet", "buffers", "snippets", "vim-dadbod-completion",
            } },
            { mode = { "<c-p>" } },
            { mode = { "<c-n>" } },
        },
    }

    vim.cmd [[
        augroup MyCompletionNvimEnable
            autocmd!
            autocmd BufEnter * lua require'completion'.on_attach()
        augroup END
    ]]
end


return M
