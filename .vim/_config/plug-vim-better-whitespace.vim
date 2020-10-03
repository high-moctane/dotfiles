if empty(globpath(&rtp, 'plugged/vim-better-whitespace'))
    finish
endif

let g:better_whitespace_ctermcolor = 'Brown'
let g:better_whitespace_guicolor = '#CB4B16'
let g:strip_whitelines_at_eof = 1
let g:strip_whitespace_on_save = 1
