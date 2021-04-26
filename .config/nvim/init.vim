" vim: set et sts=4 sw=4 fdm=marker :

" ----------------------------------------------------------------------
"   Options {{{1
" ----------------------------------------------------------------------

" Indent
set expandtab
set shiftwidth=4
set smartindent
set softtabstop=4
set tabstop=4

" Wrap
set nowrap
set scrolloff=5
set sidescroll=5
set linebreak
let &showbreak = '+++ '

" View
set number
set signcolumn=yes
set cursorline
" set cursorcolumn
set colorcolumn=80

" Search
set smartcase
set wildignorecase
set wildmode=list:longest,full

" Pairs
set matchpairs+=（:）,「:」,［:］,【:】,『:』,〈:〉,《:》,〔:〕,｛:｝

" Invisible characters
set list
set listchars=tab:\|\ ,extends:>,precedes:<,trail:-,eol:¬

" Update
set updatetime=300

" Folding
set foldmethod=syntax
set foldlevel=100

" Tmux (color)
set termguicolors

" Completion
set completeopt=menuone,noinsert,noselect

" Spell check
set spell
set spelllang=en_us,cjk

" Mouse
set mouse=nv

" Conceal
let g:vim_json_conceal = 0

" }}}1


" ----------------------------------------------------------------------
"   dein.vim {{{1
" ----------------------------------------------------------------------

let s:dotfiles_dir = expand('~/dotfiles')
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let s:dein_toml = s:dotfiles_dir . '/nvim/plugins.toml'
let s:dein_lazy_toml = s:dotfiles_dir . '/nvim/plugins_lazy.toml'

execute 'set runtimepath+=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    call dein#load_toml(s:dein_toml)
    call dein#load_toml(s:dein_lazy_toml, {'lazy': 1})

    call dein#end()

    call dein#save_state()
endif

if has('vim_starting')
    if dein#check_install()
        call dein#install()
    endif
    call dein#call_hook('source')
endif

filetype plugin indent on
syntax enable

" }}}1


" ----------------------------------------------------------------------
"   Key bindings {{{1
" ----------------------------------------------------------------------

nnoremap Y y$

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

let mapleader = "\<Space>"

" }}}1


" ----------------------------------------------------------------------
"   Commands {{{1
" ----------------------------------------------------------------------

command! Cp :%yank +

" }}}1
