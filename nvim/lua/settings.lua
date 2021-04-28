vim.cmd [[syntax enable]]
vim.cmd [[filetype plugin indent on]]

local opt = setmetatable(
    {},
    {
        __newindex = function(_, key, value)
            vim.o[key] = value
            vim.bo[key] = value
        end
    }
)

-- Indentation
opt.expandtab = true
opt.shiftwidth = 4
opt.smartindent = true
opt.softtabstop = 4
opt.tabstop = 4

-- Wrapping
vim.o.wrap = false
vim.o.scrolloff = 5
vim.o.sidescroll = 5
vim.o.linebreak = true
vim.o.showbreak = "+++ "

-- Search
vim.o.smartcase = true
vim.o.wildignorecase = true

-- Pairs
vim.o.matchpairs = vim.o.matchpairs .. ",（:）,「:」,［:］,【:】,『:』,〈:〉,《:》,〔:〕,｛:｝"

-- Invisible characters
vim.o.list = true
vim.o.listchars = "tab:| ,extends:>,precedes:<,trail:-,eol:¬"

-- Update
vim.o.updatetime = 300

-- Folding
vim.o.foldlevel = 100

-- Tmux
vim.o.termguicolors = true

-- Completion
vim.o.completeopt = "menuone,noinsert,noselect"
vim.o.shortmess = vim.o.shortmess .. "c"

-- Spell check
vim.o.spell = true
vim.o.spelllang = "en_us,cjk"

-- Mouse
vim.o.mouse = "nv"

-- View
vim.wo.number = true
vim.wo.signcolumn = "yes"
vim.wo.cursorline = true
vim.wo.cursorcolumn = true
vim.o.colorcolumn = "80"

-- Conceal
vim.g.vim_json_conceal = 0
