local hooks = Utils.MiniDepsHooks()

MiniDeps.add({ source = 'nvim-treesitter/nvim-treesitter', hooks = hooks.treesitter })
MiniDeps.add('nvim-treesitter/nvim-treesitter-textobjects')

require('nvim-treesitter.configs').setup({
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
        disable = {
            'yaml',
        },
    },
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
        'html',
        'css',
        'norg',
        'scss',
        'vue',
    },
})
