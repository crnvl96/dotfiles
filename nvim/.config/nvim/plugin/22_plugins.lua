local hooks = Utils.MiniDepsHooks()

--- These plugins don't require the `setup` call to work
MiniDeps.add('nvim-lua/plenary.nvim')
MiniDeps.add('andymass/vim-matchup')
MiniDeps.add('tpope/vim-fugitive')
MiniDeps.add('tpope/vim-sleuth')
MiniDeps.add('tpope/vim-eunuch')
MiniDeps.add('tpope/vim-rhubarb')

MiniDeps.add('MagicDuck/grug-far.nvim')
MiniDeps.add({ source = 'Saghen/blink.cmp', hooks = hooks.blink })
MiniDeps.add('danymat/neogen')
MiniDeps.add('mikavilpas/yazi.nvim')
MiniDeps.add('folke/snacks.nvim')
MiniDeps.add('GeorgesAlkhouri/nvim-aider')
MiniDeps.add('kdheepak/lazygit.nvim')
MiniDeps.add('ibhagwan/fzf-lua')

--- AI integration (requires aider.chat)
require('nvim_aider').setup()

require('yazi').setup({ open_for_directories = true })

--- Fuzzy finder
require('fzf-lua').setup({ 'ivy' })
require('fzf-lua').register_ui_select()

require('grug-far').setup()

require('neogen').setup({
    snippet_engine = 'mini',
    languages = {
        lua = { template = { annotation_convention = 'emmylua' } },
        python = { template = { annotation_convention = 'google_docstrings' } },
    },
})

require('blink.cmp').setup({
    enabled = function() return vim.bo.buftype ~= 'prompt' end,
    completion = {
        menu = { border = 'single' },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
            window = { border = 'single' },
        },
    },
    cmdline = {
        keymap = {
            ['<Tab>'] = { 'accept' },
            ['<CR>'] = { 'accept_and_enter', 'fallback' },
        },
        completion = {
            menu = { auto_show = true },
        },
    },
    signature = {
        enabled = true,
        window = { show_documentation = true, border = 'single' },
    },
    keymap = {
        preset = 'default',
        ['<C-k>'] = {},
        ['<C-i>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },
})
