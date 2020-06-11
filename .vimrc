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
"  init augroup {{{1
" ----------------------------------------------------------------------

augroup vimrc_loading
    autocmd!
augroup END

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
        Plug 'lifepillar/vim-solarized8'

        " インデント可視化
        Plug 'nathanaelkane/vim-indent-guides'

        " 閉じ括弧補完
        Plug 'cohama/lexima.vim'

        " コメントアウト
        Plug 'tyru/caw.vim'

        " Dot repeat
        Plug 'kana/vim-repeat'

        " ソースコードの中で filetype 判別
        Plug 'Shougo/context_filetype.vim'

        " ステータスバー
        " Plug 'vim-airline/vim-airline'
        " Plug 'vim-airline/vim-airline-themes'

        " Git
        Plug 'tpope/vim-fugitive'
        Plug 'airblade/vim-gitgutter'

        " 移動高速化
        Plug 'easymotion/vim-easymotion'

        " 囲まれているやつをどうにかする
        Plug 'tpope/vim-surround'

        " 言語構文？
        Plug 'sheerun/vim-polyglot'

        " ctags
        " Plug 'ludovicchabant/vim-gutentags'
        Plug 'majutsushi/tagbar'

        " Ranger
        " Plug 'iberianpig/ranger-explorer.vim'

        " ファイラ
        Plug 'preservim/nerdtree'
        Plug 'Xuyuanp/nerdtree-git-plugin'

        " markdown のプレビュー
        Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }

        " language server, 補完
        Plug 'prabirshrestha/async.vim'
        Plug 'prabirshrestha/vim-lsp'
        Plug 'mattn/vim-lsp-settings'

        Plug 'prabirshrestha/asyncomplete.vim'
        Plug 'prabirshrestha/asyncomplete-lsp.vim'
        Plug 'prabirshrestha/asyncomplete-buffer.vim'
        Plug 'prabirshrestha/asyncomplete-emoji.vim'
        Plug 'prabirshrestha/asyncomplete-file.vim'
        Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
        Plug 'prabirshrestha/asyncomplete-tags.vim'
        Plug 'yami-beta/asyncomplete-omni.vim'

        Plug 'SirVer/ultisnips'
        Plug 'honza/vim-snippets'

        " 自作
        Plug '~/GD/Documents/MyProjects/asyncomplete-nextword.vim'
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

let g:airline_powerline_fonts = 0

" }}}1


" ----------------------------------------------------------------------
" nathanaelkane/vim-indent-guides {{{1
" ----------------------------------------------------------------------

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_color_change_percent = 5

" }}}1


" ----------------------------------------------------------------------
" prabirshrestha/vim-lsp {{{1
" ----------------------------------------------------------------------

" key config
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR>    pumvisible() ? "\<C-y>" : "\<CR>"
imap <C-Space> <Plug>(asyncomplete_force_refresh)

let lsp_diagnostics_echo_cursur = 1

augroup vimrc_loading
    autocmd BufWritePre * LspDocumentFormatSync
augroup END

nnoremap <Leader>d :LspDocumentDiagnostics<CR>

" }}}1


" ----------------------------------------------------------------------
"  prabirshrestha/asyncomplete {{{1
" ----------------------------------------------------------------------

let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,noselect,preview

" buffer
call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
            \   'name': 'buffer',
            \   'whitelist': ['*'],
            \   'completor': function('asyncomplete#sources#buffer#completor'),
            \   'config': {
            \       'max_buffer_size': 5000000,
            \   },
            \   }))

" emoji
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#emoji#get_source_options({
            \   'name': 'emoji',
            \   'whitelist': ['*'],
            \   'completor': function('asyncomplete#sources#emoji#completor'),
            \   }))

" file
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
            \   'name': 'file',
            \   'whitelist': ['*'],
            \   'priority': 10,
            \   'completor': function('asyncomplete#sources#file#completor'),
            \   }))

call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
            \   'name': 'ultisnips',
            \   'whitelist': ['*'],
            \   'completor': function('asyncomplete#sources#ultisnips#completor'),
            \   }))

" nextword
call asyncomplete#register_source(asyncomplete#sources#nextword#get_source_options({
            \   'name': 'nextword',
            \   'whitelist': ['*'],
            \   'completor': function('asyncomplete#sources#nextword#completor')
            \   }))

" }}}1


" ----------------------------------------------------------------------
" iberianpig/ranger-explorer.vim {{{1
" ----------------------------------------------------------------------

" nnoremap <silent><Leader>rc :RangerOpenCurrentDir<CR>
" nnoremap <silent><Leader>rr :RangerOpenProjectRootDir<CR>

" }}}1


" ----------------------------------------------------------------------
" lifepillar/vim-solarized8 {{{1
" ----------------------------------------------------------------------

let g:solarized_old_cursor_style = 1

" }}}1


" ----------------------------------------------------------------------
" majutsushi/tagbar {{{1
" ----------------------------------------------------------------------

let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }

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
set signcolumn=yes
if has('syntax')
    set cursorline
    " set cursorcolumn
endif
set colorcolumn=80

" 検索
set hlsearch
set smartcase
set wildignorecase
set wildmode=list:longest,full

" ステータスバー
set laststatus=2
set statusline=%f\ %m%r%h%w%q%=%y[%{&enc}]\ [%l/%L,%c,%P]

" 不可視文字
set list
set listchars=tab:\|\ ,extends:>,precedes:<,trail:-

" 括弧のペア
set matchpairs+=（:）,「:」,［:］,【:】,『:』,〈:〉,《:》,〔:〕,｛:｝

" アップデート
set updatetime=300

" tags
set tags=./tags;,tags;

" 折りたたみ
set foldmethod=syntax

" tmux での色
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" python
if has('win64')
    set pythonthreehome=$HOME\scoop\apps\python\current
    set pythonthreedll=$HOME\scoop\apps\python\current\python38.dll
endif

" }}}1


" ----------------------------------------------------------------------
" Colorscheme {{{1
" ----------------------------------------------------------------------

set termguicolors
set background=light
colorscheme solarized8

" }}}1


" ----------------------------------------------------------------------
" commands {{{1
" ----------------------------------------------------------------------

" tags
command Ctags !ctags -R . > tags
command Gotags !gotags -R . > tags

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
" secure {{{1
" ----------------------------------------------------------------------

set secure

" }}}1

