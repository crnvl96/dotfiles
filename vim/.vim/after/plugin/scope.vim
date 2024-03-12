vim9script

if exists('g:loaded_scope')
    import autoload 'scope/popup.vim' as sp
    import autoload 'scope/fuzzy.vim'

    sp.OptionsSet({borderhighlight: ['Comment']})
    fuzzy.OptionsSet({
        grep_highlight_ignore_case: false,
        grep_echo_cmd: true,
        grep_poll_intervall: 200,
        timer_delay: 200,
        grep_skip_len: 1
    })

    nnoremap <C-b> <scriptcmd>fuzzy.Buffer(true)<CR>
    nnoremap <leader>sf <scriptcmd>fuzzy.File('fd --strip-cwd-prefix --hidden --follow --type file --type symlink')<CR>
    nnoremap <leader>sq <scriptcmd>fuzzy.Quickfix()<CR>
    nnoremap <leader>sg <scriptcmd>fuzzy.Grep('rg --vimgrep --no-heading --smart-case')<CR>

    augroup scope-quickfix-history
        autocmd!
        autocmd QuickFixCmdPost clist cwindow
        autocmd QuickFixCmdPost llist lwindow
    augroup END
endif
