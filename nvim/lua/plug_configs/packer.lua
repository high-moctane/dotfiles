local M = {}


M.install = function()
    local repo = "https://github.com/wbthomason/packer.nvim"
    local dst = "~/.local/share/nvim/site/pack/packer/start/packer.nvim"

    if vim.fn.isdirectory(dst) == 1 then
        print("plug_configs/packer.install: packer.nvim already exists")
        return
    end

    if vim.fn.executable("git") == 0 then
        print("plug_configs/packer.install: git command not found")
        return
    end

    os.execute("git clone " .. repo .. " " .. dst)
end


return M
