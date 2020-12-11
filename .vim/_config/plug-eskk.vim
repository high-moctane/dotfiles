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

autocmd User eskk-initialize-pre call s:eskk_initial_pre()
function! s:eskk_initial_pre()
let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
call t.add_map(',', '，')
call t.add_map('.', '。')
call eskk#register_mode_table('hira', t)
let t = eskk#table#new('rom_to_kata*', 'rom_to_kata')
call t.add_map(',', '，')
call t.add_map('.', '。')
call eskk#register_mode_table('kata', t)
endfunction
