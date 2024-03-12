vim9script

packadd cfilter

nnoremap <silent> <expr> <CR> ':cc! ' .. line('.') .. '<CR>'
