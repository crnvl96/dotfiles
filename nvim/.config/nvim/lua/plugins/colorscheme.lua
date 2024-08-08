local add = MiniDeps.add

return function()
    add('EdenEast/nightfox.nvim')

    require('nightfox').setup({
        options = {
            transparent = true,
            styles = {
                comments = 'NONE', -- Value is any valid attr-list value `:help attr-list`
                conditionals = 'NONE',
                constants = 'NONE',
                functions = 'NONE',
                keywords = 'NONE',
                numbers = 'NONE',
                operators = 'NONE',
                strings = 'NONE',
                types = 'NONE',
                variables = 'NONE',
            },
        },
    })

    vim.cmd('colorscheme duskfox')
end
