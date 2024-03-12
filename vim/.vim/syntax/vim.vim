" https://github.com/habamax/.vim/blob/master/after/syntax/vim.vim
" fix marks incorrectly highlighted
" :'[,']sort
syn match vimExMarkRange /\(^\|\s\):['`][\[a-zA-Z0-9<][,;]['`][\]a-zA-Z0-9>]/
