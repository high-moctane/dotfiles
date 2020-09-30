if empty(globpath(&rtp, 'plugged/eskk.vim'))
    finish
endif

" Local dictionary
let g:eskk#large_dictionary = {
   \   'path': expand('~/.local/share/skk/SKK-JISYO.total'),
   \   'sorted': 1,
   \   'encoding': 'euc-jp',
   \ }

" yaskkserv2
let g:eskk#server = {
    \    'host': 'localhost',
    \    'port': 1178,
    \}
