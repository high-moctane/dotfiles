scriptencoding utf-8

" font

if has("mac")
    set guifont=migu-1m-regular:h14
    set linespace=1
elseif has("unix")
    set guifont=Cica-Regular\ h14
endif

" guioptions
set guioptions-=L
set guioptions-=T
set guioptions-=m
set guioptions+=l
