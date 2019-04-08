" vim: et sts=4 sw=4 set fdm=marker :

" encoding {{{1
set encoding=utf-8
scriptencoding utf-8


" defaults.vim を読み込む {{{1
source $VIMRUNTIME/defaults.vim


" options {{{1
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
set softtabstop

" TODO:
set tags=./tags;,tags;
set title
set wildignorecase
set wildmode=list:longest,full
set t_Co=256


" key bindings {{{1
nnoremap Y y$
nnoremap <silent> <ESC> <ESC>:nohlsearch<CR>

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>


" rvim だったらこれ以上読み込まない {{{1
try
    call system('true')
catch
    set secure
    finish
endtry


" Secure {{{1
set secure

