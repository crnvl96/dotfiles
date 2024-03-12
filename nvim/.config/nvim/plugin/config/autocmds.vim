augroup GeneralAutocmds | autocmd!
    autocmd FileType * setl formatoptions=qjlron
    autocmd QuickFixCmdPost [^lc]* cwindow
    autocmd QuickFixCmdPost l*    lwindow
augroup END
