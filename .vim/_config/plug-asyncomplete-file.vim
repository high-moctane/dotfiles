if empty(globpath(&rtp, 'plugged/asyncomplete-file.vim'))
    finish
endif

call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'file',
    \ 'allowlist': ['*'],
    \ 'completor': function('asyncomplete#sources#file#completor'),
    \ }))
