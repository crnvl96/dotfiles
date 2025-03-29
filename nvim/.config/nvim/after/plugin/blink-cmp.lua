require('blink.cmp').setup({
    enabled = function() return vim.bo.buftype ~= 'prompt' end,
    completion = {
        documentation = {
            auto_show = false,
            auto_show_delay_ms = 500,
        },
        menu = {
            auto_show = true,
        },
    },
    cmdline = {
        completion = {
            menu = { auto_show = true },
        },
    },
    signature = {
        enabled = false,
        window = { show_documentation = false },
    },
    keymap = { preset = 'default' },
})
