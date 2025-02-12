Add('j-hui/fidget.nvim')
Add('olimorris/codecompanion.nvim')

local load_key = function(f)
    local path = vim.fn.stdpath('config') .. '/' .. f
    local file = io.open(path, 'r')

    if file then
        local key = file:read('*a'):gsub('%s+$', '')
        file:close()

        if not key then
            vim.notify('Missing file: ' .. f, 'ERROR')
            return nil
        end

        return key
    end

    return nil
end

vim.g.codecompanion_adapter = 'deepseek'

require('codecompanion').setup({
    display = {
        diff = {
            enabled = true,
            close_chat_at = 240,
            layout = 'vertical',
            opts = { 'filler', 'internal', 'closeoff', 'algorithm:histogram', 'context:5', 'linematch:60' },
            provider = 'mini_diff',
        },
    },
    strategies = {
        chat = {
            adapter = vim.g.codecompanion_adapter,
            keymaps = {
                completion = {
                    modes = {
                        i = '<C-n>',
                    },
                },
            },
        },
        inline = { adapter = vim.g.codecompanion_adapter },
        cmd = { adapter = vim.g.codecompanion_adapter },
    },
    adapters = {
        huggingface = require('codecompanion.adapters').extend('huggingface', {
            env = { api_key = load_key('huggingface') },
            schema = {
                model = {
                    default = 'deepseek-ai/DeepSeek-R1-Distill-Qwen-32B',
                },
            },
        }),
        anthropic = require('codecompanion.adapters').extend('anthropic', {
            env = { api_key = load_key('anthropic') },
            schema = {
                model = {
                    default = 'claude-3-5-sonnet-20241022',
                },
            },
        }),
        deepseek = require('codecompanion.adapters').extend('deepseek', {
            env = { api_key = load_key('deepseek') },
            schema = {
                model = {
                    default = 'deepseek-chat',
                },
            },
        }),
    },
})
