" https://github.com/habamax/.vim/blob/master/after/syntax/vim.vim
if exists('b:current_syntax')
    finish
endif

syn match vimExMarkRange /\(^\|\s\):['`][\[a-zA-Z0-9<][,;]['`][\]a-zA-Z0-9>]/
