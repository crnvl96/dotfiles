vim9script

def SaveLastReg()
    if v:event['regname'] == "" && v:event['operator'] == 'y'
        for i in range(8, 1, -1)
            setreg(string(i + 1), getreg(string(i)))
        endfor
        @1 = v:event['regcontents'][0]
    endif
enddef

def ResizeWindows()
    tabdo wincmd =
enddef

augroup GeneralAutocmds | autocmd!
    autocmd TextYankPost * SaveLastReg()
    autocmd FileType help,vim-plug,qf nnoremap <buffer><silent> q :close<CR>
    autocmd VimResized * ResizeWindows()
    # create directories when needed, when saving a file
    autocmd BufWritePre * mkdir(expand('<afile>:p:h'), 'p')
    # Format usin 'gq'. :h fo-table
    autocmd FileType * setl formatoptions=qjlron
    # Tell vim to automatically open the quickfix and location window after :make,
    # :grep, :lvimgrep and friends if there are valid locations/errors:
    # NOTE: Does not work with caddexpr (:g/pat/caddexpr ...) since it just adds entries.
    # ':make', ':grep' and so on are called quickfix commands, they trigger QuickFixCmdPost.
    # [^l]* to match commands that don't start with l (l* does the opposite).
    # quickfix commands are cgetexpr, lgetexpr, lgrep, grep, etc.
    # exclude cadexppr also ([^c]*), otherwise g//caddexpr will open quickfix after the first match.
    # https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
    autocmd QuickFixCmdPost [^lc]* cwindow
    autocmd QuickFixCmdPost l*    lwindow
    # Remove any trailing whitespace that is in the file
    autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif
augroup END
