vim9script

# ----------------------------------------------------------------------
# Grep function

if executable('rg')
    set grepprg=rg\ -H\ --no-heading\ --vimgrep
    set grepformat=%f:%l:%c:%m
endif

command -nargs=1 -bar Grep {
    var cmd = $"{&grepprg} {expandcmd(<q-args>)}"
    cgetexpr system(cmd)
    setqflist([], 'a', {title: cmd})
}

nnoremap <leader>g :Grep<space>
