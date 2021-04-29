local M = {}


M.config = function()
    vim.g["eskk#large_dictionary"] = {
        path = vim.fn.expand("~/.local/share/skk/SKK-JISYO.total"),
        sorted = 1,
        encoding = "euc-jp",
    }
end


return M
