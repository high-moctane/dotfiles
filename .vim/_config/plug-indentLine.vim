if empty(globpath(&rtp, 'plugged/indentLine'))
    finish
endif

let g:indentLine_fileTypeExclude = ['help']
