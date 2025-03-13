local cmd = vim.api.nvim_create_autocmd
local set = vim.keymap.set
local adapter = 'deepseek'

require('codecompanion').setup({
    display = { chat = { window = { layout = 'vertical' } } },
    strategies = {
        inline = { adapter = adapter },
        cmd = { adapter = adapter },
        chat = {
            adapter = adapter,
            slash_commands = {
                file = { opts = { provider = 'fzf_lua' } },
                buffer = { opts = { provider = 'fzf_lua' } },
                help = { opts = { provider = 'fzf_lua' } },
                symbols = { opts = { provider = 'fzf_lua' } },
            },
            keymaps = { completion = { modes = { i = '<C-n>' } } },
        },
    },
    adapters = {
        huggingface = require('codecompanion.adapters').extend('huggingface', {
            env = { api_key = Utils.ReadFromFile('huggingface') },
            schema = { model = { default = 'deepseek-ai/DeepSeek-R1-Distill-Qwen-32B' } },
        }),
        anthropic = require('codecompanion.adapters').extend('anthropic', {
            env = { api_key = Utils.ReadFromFile('anthropic') },
            schema = { model = { default = 'claude-3-7-sonnet-20250219' } },
        }),
        deepseek = require('codecompanion.adapters').extend('deepseek', {
            env = { api_key = Utils.ReadFromFile('deepseek') },
            schema = { model = { default = 'deepseek-reasoner' } },
        }),
    },
})

Utils.Group('crnvl96-codecompanion-fidget-integration', function(g)
    local handlers = {}
    local progress = require('fidget.progress')

    cmd('User', {
        pattern = 'CodeCompanionRequestStarted',
        group = g,
        callback = function(e)
            local parts = {}

            table.insert(parts, e.data.adapter.formatted_name)

            if e.data.adapter.model and e.data.adapter.model ~= '' then
                table.insert(parts, '(' .. e.data.adapter.model .. ')')
            end

            local handler = progress.handle.create({
                title = ' Requesting assistance (' .. e.data.strategy .. ')',
                message = 'In progress...',
                lsp_client = {
                    name = table.concat(parts, ' '),
                },
            })

            handlers[e.data.id] = handler
        end,
    })

    cmd('User', {
        pattern = 'CodeCompanionRequestFinished',
        group = g,
        callback = function(e)
            local handler = handlers[e.data.id]
            handlers[e.data.id] = nil

            if handler then
                if e.data.status == 'success' then
                    handler.message = 'Completed'
                elseif e.data.status == 'error' then
                    handler.message = ' Error'
                else
                    handler.message = '󰜺 Cancelled'
                end

                handler:finish()
            end
        end,
    })
end)

set({ 'n', 'x' }, '<Leader>cc', '<Cmd>CodeCompanionChat Toggle<CR>', { desc = 'Toggle AI chat' })
set('x', 'ga', ':CodeCompanionChat Add<CR>', { desc = 'Add to AI chat' })

Utils.Abbr('cc', 'CodeCompanion')
Utils.Abbr('ccc', 'CodeCompanionChat Toggle')
