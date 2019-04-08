" vim: set et sts=4 sw=4 fdm=marker :

" encoding {{{1
set encoding=utf-8
scriptencoding utf-8
" }}}1


" defaults.vim を読み込む {{{1
source $VIMRUNTIME/defaults.vim
" }}}1


" options {{{1
" TODO: Mac のみ
"   なんか日本語化しない？？
if has('unix')
    language ja_JP.UTF-8
    language messages ja_JP.UTF-8
end

set ambiwidth=double
set autoindent

" TODO
" set belloff& belloff+=esc

if has('linebreak')
    " TODO
    " set linebreak
    set breakindent
    set breakindentopt& breakindentopt+=sbr
    let &showbreak = '+++ '
end

set cursorline
set expandtab

" TODO
" set formatoptions& formatoptions+=mM

set hlsearch
set laststatus=2
set list
" set listchars=tab:\|\ ,extends:<,trail:-,eol:⏎
set listchars=tab:\|\ ,extends:<,trail:-

" TODO
" set matchpairs&

set matchpairs+=（:）,「:」,［:］,【:】,『:』,〈:〉,《:》,〔:〕,｛:｝
set number

" TODO
" set sessionoptions+=tabpages,unix,slash

set shiftwidth=4
set smartcase
set smartindent
set smarttab

" TODO
" set softtabstop=-1

" TODO:
set tags=./tags;,tags;
set title
set updatetime=100
set wildignorecase
set wildmode=list:longest,full
set t_Co=256
" }}}1


" key bindings {{{1
nnoremap Y y$
nnoremap <silent> <ESC> <ESC>:nohlsearch<CR>

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
" }}}1


" rvim だったらこれ以上読み込まない {{{1
try
    call system('true')
catch
    set secure
    finish
endtry
" }}}1


" Plugins {{{1

if has("unix")
    let s:plug_dir = expand('~/.vim/plugged')
elseif has("win32")
    let s:plug_dir = expand('~\vimfiles\plugged')
endif

if isdirectory(s:plug_dir)
    call plug#begin(s:plug_dir)
        " Plugins list {{{2

        " カラースキーム
        Plug 'altercation/vim-colors-solarized'

        " ジャンプできる
        Plug 'easymotion/vim-easymotion'

        " 自動整形
        Plug 'junegunn/vim-easy-align'

        " インデントを表示する
        Plug 'nathanaelkane/vim-indent-guides'

        " カッコを補完してくれるやつ
        Plug 'Raimondi/delimitMate'

        " コメントアウト
        Plug 'scrooloose/nerdcommenter'

        " 非同期実行のプラグイン
        " TODO: ちゃんとインストールする方法は？？
        " Plug 'Shougo/vimproc.vim', {'do' : 'make'}

        " すごそうだけどすぐには使えなそうだ
        " Plug 'terryma/vim-multiple-cursors'

        " Git
        Plug 'tpope/vim-fugitive'

        " なんか補完してくれるやつ
        " TODO: コアライブラリが呼び出せてない？？
        " function! BuildYCM(info)
            " if a:info.status == 'installed' || a:info.force
                " !python install.py --clang-completer --cs-completer --go-completer
            " endif
        " endfunction
        " Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }

        " ステータスバーがかっこよくなる
        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'

        " 日本語マニュアル
        Plug 'vim-jp/vimdoc-ja'

        " Linter
        Plug 'w0rp/ale'

        " Git の変更部分を表示する
        Plug 'airblade/vim-gitgutter'
        " }}}2
    call plug#end()

    " Plugins settings {{{2

    " altercation/vim-colors-solarized {{{3
    let g:solarized_termcolors=256

    " junegunn/vim-easy-align {{{3
    xmap ga <Plug>(EasyAlign)
    nmap ga <Plug>(EasyAlign)

    " nathanaelkane/vim-indent-guides {{{3
    let g:indent_guides_enable_on_vim_startup = 1

    " Raimondi/delimitMate {{{3
    let g:delimitMate_expand_space = 1
    let g:delimitMate_expand_inside_quotes = 1
    let g:delimitMate_expand_cr = 1
    let g:delimitMate_jump_expansion = 1


    " scrooloose/nerdcommenter {{{3
    let g:NERDSpaceDelims = 1

    " Shougo/vimproc.vim {{{3
    let g:vimproc#download_windows_dll = 1

    " w0rp/ale {{{3

    " }}}2


    " Plugins 設定後の設定 {{{2
    colorscheme solarized
    set helplang=ja,en
    " }}}2
" }}}1
endif
" }}}1


" Secure {{{1
set secure
" }}}1

