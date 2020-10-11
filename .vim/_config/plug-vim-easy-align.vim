if empty(globpath(&rtp, 'plugged/vim-easy-align'))
    finish
endif

xmap <Leader>g <Plug>(EasyAlign)
nmap <Leader>g <Plug>(EasyAlign)
