vim9script

if exists("g:loaded_commentary")
    augroup MyVimCommentary | autocmd!
        autocmd FileType c,cpp setlocal commentstring=//\ %s |
                    \ command! CommentBlock setlocal commentstring=/*%s*/ |
                    \ command! CommentLines setlocal commentstring=//\ %s
    augroup END
endif
