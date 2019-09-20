" vim: set et sts=4 sw=4 fdm=marker :

" ----------------------------------------------------------------------
" encoding {{{1
" ----------------------------------------------------------------------

set encoding=utf-8
scriptencoding utf-8

" }}}1


" ----------------------------------------------------------------------
" defaults.vim {{{1
" ----------------------------------------------------------------------

source $VIMRUNTIME/defaults.vim

" }}}1


" ----------------------------------------------------------------------
" options {{{1
" ----------------------------------------------------------------------

" 全角文字
set ambiwidth=double

" インデント
set autoindent
set expandtab
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=4
set tabstop=4

" 長い行の折り返し
set nowrap
set sidescroll=5
" set &showbreak = "+++ " " これなら折返しのときに便利

" 表示関係
set number
if has('syntax')
    set cursorline
    set cursorcolumn
endif

" 検索
set hlsearch
set smartcase
set wildignorecase
set wildmode=list:longest,full

" ステータスバー
set laststatus=2

" 不可視文字
set list
set listchars=tab:\|\ ,extends:>,precedes:<,trail:-,eol:⏎

" 括弧のペア
set matchpairs+=（:）,「:」,［:］,【:】,『:』,〈:〉,《:》,〔:〕,｛:｝

" アップデート
set updatetime=300

" tags
set tags=./tags;,tags;

" 折りたたみ
set foldmethod=syntax

" }}}1


" ----------------------------------------------------------------------
" key bindings {{{1
" ----------------------------------------------------------------------

nnoremap Y y$

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" 全部をクリップボードにコピー
nnoremap <Leader>cp gg"+yG

" }}}1


" ----------------------------------------------------------------------
" plug {{{1
" ----------------------------------------------------------------------

if has("unix")
    let s:plug_dir = expand('~/.vim/plugged')
elseif has("win32")
    let s:plug_dir = expand('~\vimfiles\plugged')
endif

if isdirectory(s:plug_dir)
    call plug#begin(s:plug_dir)
        " 日本語マニュアル
        Plug 'vim-jp/vimdoc-ja'

        " カラースキーム
        Plug 'chriskempson/base16-vim'

        " 閉じ括弧補完
        Plug 'cohama/lexima.vim'

        " コメントアウト
        Plug 'tyru/caw.vim'

        " Dot repeat
        Plug 'kana/vim-repeat'

        " ソースコードの中で filetype 判別
        Plug 'Shougo/context_filetype.vim'

        " ステータスバー
        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'

        " Git
        Plug 'tpope/vim-fugitive'
        Plug 'airblade/vim-gitgutter'

        " ツリー
        Plug 'scrooloose/nerdtree'
        Plug 'Xuyuanp/nerdtree-git-plugin'

        " language server
        Plug 'prabirshrestha/async.vim'
        Plug 'prabirshrestha/vim-lsp'
    call plug#end()
endif

" }}}1


" ----------------------------------------------------------------------
" scrooloose/nerdtree {{{1
" ----------------------------------------------------------------------

" トグル
nnoremap <Leader>t :NERDTreeToggle<CR>

" }}}1


" ----------------------------------------------------------------------
" vim-airline/vim-airline {{{1
" ----------------------------------------------------------------------

let g:airline_powerline_fonts = 1

" }}}1


" ----------------------------------------------------------------------
" prabirshrestha/vim-lsp {{{1
" ----------------------------------------------------------------------

" python
if executable("pyls")
    autocmd User lsp_setup call lsp#register_server({
        \   "name": "pyls",
        \   "cmd": {server_info->["pyls"]},
        \   "whitelist": ["python"],
        \   })
endif


" }}}1


" ----------------------------------------------------------------------
" Colorscheme {{{1
" ----------------------------------------------------------------------

set termguicolors
set background=dark
colorscheme base16-default-dark

" }}}1


" ----------------------------------------------------------------------
" secure {{{1
" ----------------------------------------------------------------------

set secure

" }}}1

