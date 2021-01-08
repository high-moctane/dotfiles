UsePlugin 'lightline.vim'

let g:lightline = {
    \ 'colorscheme': 'one',
    \ 'active': {
    \   'right': [ [ 'lsp_errors', 'lsp_warnings', 'lsp_ok', 'lineinfo' ],
    \              [ 'percent' ],
    \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
    \ },
    \ 'component_expand': {
    \   'lsp_warnings': 'lightline_lsp#warnings',
    \   'lsp_errors':   'lightline_lsp#errors',
    \   'lsp_ok':       'lightline_lsp#ok',
    \ },
    \ 'component_type': {
    \   'lsp_warnings': 'warning',
    \   'lsp_errors':   'error',
    \   'lsp_ok':       'middle',
    \ },
    \ }
