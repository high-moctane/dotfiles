" vim: set et sts=4 sw=4 fdm=marker :

" Required
"   - vim-plug
"       - ディレクトリがない場合は読み込まれない

" ----------------------------------------------------------------------
"   Encoding {{{1
" ----------------------------------------------------------------------

set encoding=utf-8
scriptencoding utf-8

" }}}1


" ----------------------------------------------------------------------
"   defaults.vim {{{1
" ----------------------------------------------------------------------

source $VIMRUNTIME/defaults.vim

" }}}1


" ----------------------------------------------------------------------
"   Options {{{1
" ----------------------------------------------------------------------

" 日本語
set ambiwidth=double

" インデント
set autoindent
set expandtab
set shiftwidth=4
if has('smartindent')
    set smartindent
endif
set smarttab
set softtabstop=4
set tabstop=4

" 折返し
set nowrap
set scrolloff=5
set sidescroll=5
if has('linebreak')
    set linebreak
    let &showbreak = "+++ "
endif

" 表示
set number
if has('signs')
    set signcolumn=yes
endif
if has('syntax')
    set cursorline
    set cursorcolumn
    set colorcolumn=80
endif

" サーチ
if has('extra_search')
    set hlsearch
endif
set smartcase
set wildignorecase
set wildmode=list:longest,full

" ステータスバー
set laststatus=2

" 括弧のペア
set matchpairs+=（:）,「:」,［:］,【:】,『:』,〈:〉,《:》,〔:〕,｛:｝

" 不可視文字
set list
set listchars=tab:\|\ ,extends:>,precedes:<,trail:-,eol:¬

" アップデート
set updatetime=300

" tags
set tags=./tags;,tags;

" 折りたたみ
if has('folding')
    set foldmethod=syntax
endif

" Tmux（色）
if has('termguicolors')
    set termguicolors
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" 補完
if has('textprop')
    set completeopt=menuone,popup,noinsert,noselect
else
    set completeopt=menuone,noinsert,noselect
endif

" ベル
set belloff=all

" }}}1


" ----------------------------------------------------------------------
"   vim-plug {{{1
" ----------------------------------------------------------------------

if has('unix')
    let s:plug_dir = expand('~/.vim/plugged')
elseif has('win32')
    let s:plug_dir = expand('~\vimfiles\plugged')
else
    let s:plug_dir = ''
endif

if isdirectory(s:plug_dir)
    call plug#begin(s:plug_dir)
        " 日本語マニュアル
        Plug 'vim-jp/vimdoc-ja'

        " カラースキーム
        Plug 'lifepillar/vim-solarized8'

        " インデント可視化
        " Plug 'nathanaelkane/vim-indent-guides'
        Plug 'Yggdroot/indentLine'

        " 補完
        Plug 'prabirshrestha/asyncomplete.vim'
        Plug 'prabirshrestha/asyncomplete-buffer.vim'
        Plug 'prabirshrestha/asyncomplete-emoji.vim'
        Plug 'prabirshrestha/asyncomplete-file.vim'
        Plug 'prabirshrestha/asyncomplete-lsp.vim'
        Plug 'prabirshrestha/vim-lsp'
        Plug 'mattn/vim-lsp-settings'

        " 括弧を閉じる
        Plug 'cohama/lexima.vim'

        " コメントアウト
        Plug 'tyru/caw.vim'

        " リピート
        Plug 'kana/vim-repeat'

        " ファイル内ファイルタイプ判別
        Plug 'Shougo/context_filetype.vim'

        " ファイルタイプ判別
        " なんか Rust のフォーマットに失敗するのでコメントアウトしてる
        " Plug 'sheerun/vim-polyglot'

        " Git
        Plug 'tpope/vim-fugitive'
        Plug 'airblade/vim-gitgutter'

        " Ctags
        Plug 'ludovicchabant/vim-gutentags'
        Plug 'preservim/tagbar'

        " 囲んでるやつをいい感じにする
        Plug 'tpope/vim-surround'

        " ステータスライン
        Plug 'itchyny/lightline.vim'
        Plug 'halkn/lightline-lsp'
    call plug#end()
endif

" }}}1


" ----------------------------------------------------------------------
"   Plugin Settings {{{1
" ----------------------------------------------------------------------

call map(sort(split(globpath(&runtimepath, '_config/*.vim'))), {->[execute('exec "so" v:val')]})

" }}}1


" ----------------------------------------------------------------------
"   Colorscheme {{{1
" ----------------------------------------------------------------------

if len(globpath(&rtp, 'plugged/vim-solarized8')) > 0
    colorscheme solarized8
end

" }}}1
