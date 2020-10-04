if empty(globpath(&rtp, 'plugged/indentLine'))
    finish
endif

let g:indentLine_fileTypeExclude = ['help']
let g:indentLine_showFirstIndentLevel = 1
