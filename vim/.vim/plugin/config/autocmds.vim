vim9script

def ResizeWindows()
    tabdo wincmd =
enddef

def AutoCreateDirs()
    mkdir(expand('<afile>:p:h'), 'p')
enddef

def HandleOpenQf()
    cwindow
enddef

def HandleOpenLC()
    lwindow
enddef

def TrimWhitespace()
    silent! :%s/\s\+$//ge
enddef

def Colorscheme()
    hi! default link StatusLine Normal
    hi! default link StatusLineNC Normal
    hi! default link PMenuSbar Normal
    hi! default link PMenu Normal
    hi! default link FloatBorder Normal
    hi! default link LspInfoBorder Normal
    hi! default link NormalFloat Normal
enddef

augroup GeneralAutocmds | autocmd!
    autocmd VimResized * ResizeWindows()
    autocmd BufWritePre * AutoCreateDirs()
    autocmd QuickFixCmdPost [^lc]* HandleOpenQf()
    autocmd QuickFixCmdPost l* HandleOpenLC()
    autocmd BufRead,BufWrite * TrimWhitespace()
    autocmd BufEnter * Colorscheme()
    autocmd FileType json syntax match Comment +\/\/.\+$+
augroup END
