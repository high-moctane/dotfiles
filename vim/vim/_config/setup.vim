function! s:setup() abort
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

command! Setup call s:setup()
