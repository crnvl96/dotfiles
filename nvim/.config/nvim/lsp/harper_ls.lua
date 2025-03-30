vim.lsp.config.harper_ls = {
    cmd = { Brew .. 'harper-ls', '--stdio' },
    filetypes = { 'markdown', 'gitcommit' },
    settings = {
        ['harper-ls'] = {
            userDictPath = '~/.config/nvim/spell/en.utf-8.add',
            linters = {
                ToDoHyphen = false,
                SentenceCapitalization = true,
                SpellCheck = true,
            },
            isolateEnglish = true,
            markdown = {
                IgnoreLinkTitle = true,
            },
        },
    },
}
