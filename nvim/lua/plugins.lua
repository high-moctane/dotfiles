local status, packer = pcall(require, "packer") if not status then
    return
end

packer.startup(function(use)
    use "wbthomason/packer.nvim"

    -- Indent guide
    use {
        "Yggdroot/indentLine",
        config = require"plug_configs/indentLine".config,
    }

    -- Comment out
    use "tyru/caw.vim"

    -- Git
    use "tpope/vim-fugitive"
    use "airblade/vim-gitgutter"

    -- Surround
    use "tpope/vim-surround"

    -- Trim whitespace
    use {
        "ntpeters/vim-better-whitespace",
        config = require"plug_configs/vim-better-whitespace".config,
    }

    -- SKK
    use {
        "tyru/eskk.vim",
        config = require"plug_configs/eskk".config,
    }

    -- Aligning
    use {
        "junegunn/vim-easy-align",
        config = require"plug_configs/vim-easy-align".config,
    }

    -- Syntax
    use {
        "nvim-treesitter/nvim-treesitter",
        run = require"plug_configs/nvim-treesitter".run,
        config = require"plug_configs/nvim-treesitter".config,
    }

    -- Database
    use "tpope/vim-dadbod"
    use "kristijanhusak/vim-dadbod-ui"

    -- Snippets
    use {
        "norcalli/snippets.nvim",
        config = require"plug_configs/snippets".config,
    }

    -- LSP config
    use {
        "neovim/nvim-lspconfig",
        config = require"plug_configs/nvim-lspconfig".config,
    }

    -- LSP install servers
    use "kabouzeid/nvim-lspinstall"

    -- Completion
    use {
        "nvim-lua/completion-nvim",
        config = require"plug_configs/completion-nvim".config,
    }

    use "steelsojka/completion-buffers"
    use "albertoCaroM/completion-tmux"
    use "nvim-treesitter/completion-treesitter"
end)

vim.cmd "PackerCompile"
