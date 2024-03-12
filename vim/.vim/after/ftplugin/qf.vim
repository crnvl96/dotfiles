vim9script

if getwininfo(win_getid())[0]['loclist'] == 1
    nnoremap <silent> <expr> <CR> ':ll! ' .. line('.') .. '<CR>' .. '<C-w><C-p>'
else
    nnoremap <silent> <expr> <CR> ':cc! ' .. line('.') .. '<CR>' .. '<C-w><C-p>'
endif



packadd cfilter
