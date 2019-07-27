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

    " カラースキーム
    Plug 'frankier/neovim-colors-solarized-truecolor-only'

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

    call plug#end()
endif

" }}}1


" ----------------------------------------------------------------------
" neoclide/coc.nvim {{{1
" ----------------------------------------------------------------------

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

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

augroup MyAutoCmd
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

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

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
" カラースキーム {{{1
" ----------------------------------------------------------------------

if isdirectory(s:plug_dir . '/neovim-colors-solarized-truecolor-only')
    set background=light
    colorscheme solarized
endif

" }}}1
