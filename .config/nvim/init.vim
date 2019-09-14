" vim: set et sts=4 sw=4 fdm=marker :

" ----------------------------------------------------------------------
" 初期化 {{{1
" ----------------------------------------------------------------------

" augroup の初期化
augroup MyAutoCmd
    autocmd!
augroup END

" }}}1


" ----------------------------------------------------------------------
"  全体の設定 {{{1
" ----------------------------------------------------------------------

" カーソルのハイライト
set cursorline
set cursorcolumn

" タブやインデント
set tabstop=4
set expandtab
set shiftwidth=4
set smartindent

" 検索
set smartcase
set wildignorecase
set wildmode=list:longest,full


" 括弧の対応
:set matchpairs+=（:）,「:」,【:】,［:］,『:』,〈:〉,《:》,〔:〕,｛:｝

" 全角文字
set ambiwidth=double

" 更新時間
set updatetime=300

" 表示
set number

" カラースキーム
set termguicolors
set background=light

" 折りたたみ
set foldmethod=syntax

" }}}1


" ----------------------------------------------------------------------
"  キーバインド {{{1
" ----------------------------------------------------------------------

" 行末までヤンク
nnoremap Y y$

" 検索ハイライトを消す
nnoremap <silent> <ESC> <ESC>:nohlsearch<CR>

" コマンドモードの履歴
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" 全部をクリップボードにコピー
nnoremap <Leader>cp gg"+yG

" }}}1


" ----------------------------------------------------------------------
"  vim-plug {{{1
" ----------------------------------------------------------------------

if has('unix')
    let s:plug_dir = expand('~/.local/share/nvim/plugged')
elseif has('win32')
    let s:plugdir = expand('~\AppData\Local\nvim\plugged')
endif

if isdirectory(s:plug_dir)
    call plug#begin(s:plug_dir)

    " 日本語ヘルプ
    Plug 'vim-jp/vimdoc-ja'

    " カラースキーム
    Plug 'lifepillar/vim-solarized8'

    " 閉じ括弧の補完など
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

    " 補完プラグイン
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " Git
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'

    " ツリー
    Plug 'scrooloose/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'

    call plug#end()
endif

" }}}1


" ----------------------------------------------------------------------
" neoclide/coc.nvim {{{1
" ----------------------------------------------------------------------

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
" set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Format on save
augroup mygroup
    autocmd!
    autocmd bufWritePost * call CocAction('format')
augroup end


" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" }}}1


" ----------------------------------------------------------------------
"  scrooloose/nerdtree {{{1
" ----------------------------------------------------------------------

" トグル
nnoremap <Leader>t :NERDTreeToggle<CR>

" }}}1


" ----------------------------------------------------------------------
" lifepillar/vim-solarized8
" ----------------------------------------------------------------------

let g:solarized_old_cursor_style = 1


" ----------------------------------------------------------------------
" カラースキーム {{{1
" ----------------------------------------------------------------------

colorscheme solarized8

" }}}1
