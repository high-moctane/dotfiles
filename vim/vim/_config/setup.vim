function! s:setup_plug() abort
    PlugInstall
    qa
endfunction

function! s:setup_coc() abort
    if executable('bash')
        CocInstall -sync coc-go
    endif

    if executable('go')
        CocInstall -sync coc-go
    endif

    CocInstall -sync coc-html

    CocInstall -sync coc-json

    if executable('python')
        CocInstall -sync coc-pyright
    endif

    if executable('cargo')
        CocInstall -sync coc-rust-analyzer
    endif

    CocInstall -sync coc-tsserver
    qa
endfunction

command! SetupPlug call s:setup_plug()
command! SetupCoC call s:setup_coc()
