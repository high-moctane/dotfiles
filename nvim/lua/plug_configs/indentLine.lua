local M = {}


M.config = function()
    vim.g.indentLine_fileTypeExclude = { "help" }
    vim.g.indentLine_showFirstIndentLevel = 1
end


return M
