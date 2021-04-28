local M = {}


local skk_repo = "https://github.com/skk-dev/dict.git"
local skk_dir = vim.fn.expand("~/.local/share/skk")
local skk_dict_dir = skk_dir .. "/dict"
local large_dictionary_path = skk_dir .. "/SKK-JISYO.total"


M.config = function()
    vim.g["eskk#large_dictionary"] = {
        path = large_dictionary_path,
        sorted = 1,
        encoding = "euc-jp",
    }
end


M.sync_skk_dictionary = function()
    if vim.fn.isdirectory(skk_dict_dir) == 0 then
        M.clone_skk_dictionary()
    else
        M.pull_skk_dictionary()
    end

    M.build_skk_dictionary()
end


M.clone_skk_dictionary = function()
    if not vim.fn.executable("git") then
        print("plug_configs/eskk.clone_skk_dictionary: git command not found")
        return
    end

    vim.fn.mkdir(skk_dir, "p")

    os.execute("git clone --depth 1 " .. skk_repo .. " " .. skk_dict_dir)
end


M.pull_skk_dictionary = function()
    if not vim.fn.executable("git") then
        print("plug_configs/eskk.pull_skk_dictionary: git command not found")
        return
    end

    os.execute("git -C " .. skk_dict_dir .." pull")
end


M.build_skk_dictionary = function()
    if vim.fn.isdirectory(skk_dict_dir) == 0 then
        print("plug_configs/eskk.build_skk_dictionary: skk dict repo not found")
        return
    end

    if not vim.fn.executable("skkdic-expr2") then
        print("plug_configs/eskk.install_skk_dictionary: skkdic-expr2 command not found")
        return
    end

    local jisyo_l = skk_dir .. "/dict/SKK-JISYO.L"
    local jisyo_jinmei = skk_dir .. "/dict/SKK-JISYO.jinmei"
    local jisyo_geo = skk_dir .. "/dict/SKK-JISYO.geo"
    local jisyo_station = skk_dir .. "/dict/SKK-JISYO.station"
    local jisyo_propernoun = skk_dir .. "/dict/SKK-JISYO.propernoun"

    os.execute(
        "skkdic-expr2 "
        .. jisyo_l .. " "
        .. jisyo_jinmei .. " "
        .. jisyo_geo .. " "
        .. jisyo_station .. " "
        .. jisyo_propernoun .. " "
        .. "> " .. large_dictionary_path
    )
end


return M
