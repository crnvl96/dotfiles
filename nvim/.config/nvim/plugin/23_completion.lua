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
