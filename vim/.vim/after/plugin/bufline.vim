vim9script

if exists("g:loaded_bufline")
    highlight link User1 StatusLine
    highlight link User2 StatusLine
    highlight link User3 StatusLine
    highlight link User4 StatusLine
    g:BuflineSetup({ highlight: true, showbufnr: true })
endif
