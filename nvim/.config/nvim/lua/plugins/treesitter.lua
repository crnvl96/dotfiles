Add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = {
        post_checkout = function() vim.cmd('TSUpdate') end,
    },
})

require('nvim-treesitter.configs').setup({
    highlight = { enable = true },
    indent = { enable = true, disable = { 'yaml' } },
    sync_install = false,
    auto_install = true,
    ensure_installed = {
        'c',
        'vim',
        'vimdoc',
        'query',
        'markdown',
        'markdown_inline',
        'lua',
        'javascript',
        'typescript',
        'tsx',
        'python',
        'sql',
        'csv',
    },
})
