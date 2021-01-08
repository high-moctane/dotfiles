UsePlugin 'asyncomplete-emoji.vim'

call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'emoji',
    \ 'allowlist': ['*'],
    \ 'completor': function('asyncomplete#sources#emoji#completor'),
    \ }))
