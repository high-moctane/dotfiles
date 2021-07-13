UsePlugin 'coc.nvim'

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

nmap <silent> <Leader>ld <Plug>(coc-definition)
nmap <silent> <Leader>ly <Plug>(coc-type-definition)
nmap <silent> <Leader>li <Plug>(coc-implementation)
nmap <silent> <Leader>lr <Plug>(coc-references)
nmap <silent> <Leader>ln <Plug>(coc-rename)
nmap <silent> <Leader>lh :call CocAction('doHover')<CR>
