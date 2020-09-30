if empty(globpath(&rtp, 'plugged/vim-lsp'))
    finish
endif

set foldmethod=expr
    \ foldexpr=lsp#ui#vim#folding#foldexpr()
    \ foldtext=lsp#ui#vim#folding#foldtext()

nnoremap <Leader>ld :LspDocumentDiagnostics<CR>
nnoremap <Leader>lf :LspDocumentFormat<CR>

augroup MyVimLspFormatOnSave
    autocmd!
    autocmd BufWritePre * LspDocumentFormatSync
augroup END
