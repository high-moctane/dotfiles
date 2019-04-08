scriptencoding utf-8

" フォント
" なんかプラグイン入れると日本語フォントが変になるので
" TODO: Macのみ
if has('unix')
    set guifont=Ricty_Diminished:h15
    augroup japanese_font
        autocmd!
        autocmd BufEnter,BufRead,BufNewFile * set guifont=Ricty_Diminished:h15
    augroup END
end
