local cmd = vim.api.nvim_create_autocmd
local set = vim.keymap.set
local adapter = 'anthropic'

require('codecompanion').setup({
    display = {
        chat = {
            show_settings = true,
        },
        diff = {
            enabled = true,
            close_chat_at = 360,
            opts = { 'filler', 'internal', 'closeoff', 'algorithm:histogram', 'context:5', 'linematch:60' },
        },
    },
    strategies = {
        inline = { adapter = adapter },
        cmd = { adapter = adapter },
        chat = {
            adapter = adapter,
            tools = {
                mcp = {
                    callback = function() return require('mcphub.extensions.codecompanion') end,
                    description = 'Call tools and resources from the MCP Servers',
                    opts = { requires_approval = true },
                },
            },
            slash_commands = {
                file = { opts = { provider = 'fzf_lua' } },
                buffer = { opts = { provider = 'fzf_lua' } },
                help = { opts = { provider = 'fzf_lua' } },
                symbols = { opts = { provider = 'fzf_lua' } },
            },
        },
    },
    adapters = {
        huggingface = require('codecompanion.adapters').extend('huggingface', {
            env = { api_key = Utils.ReadFromFile('huggingface') },
            schema = { model = { default = 'deepseek-ai/DeepSeek-R1-Distill-Qwen-32B' } },
        }),
        anthropic = require('codecompanion.adapters').extend('anthropic', {
            env = { api_key = Utils.ReadFromFile('anthropic') },
            schema = {
                model = {
                    choices = {
                        ['claude-3-7-sonnet-20250219'] = { opts = { can_reason = false } },
                        'claude-3-5-sonnet-20241022',
                        'claude-3-5-haiku-20241022',
                        'claude-3-opus-20240229',
                        'claude-2.1',
                    },
                    default = 'claude-3-7-sonnet-20250219',
                },
            },
        }),
        deepseek = require('codecompanion.adapters').extend('deepseek', {
            env = { api_key = Utils.ReadFromFile('deepseek') },
            schema = { model = { default = 'deepseek-chat' } },
        }),
    },
})

local codecompanion_status = {
    active_requests = {},
    count = 0,
}

function _G.codecompanion_statusline()
    if codecompanion_status.count > 0 then
        return ' 󱜚  [cc running...]' -- Icon showing CodeCompanion is active
    else
        return ''
    end
end

Utils.Group('crnvl96-codecompanion-statusline-integration', function(g)
    cmd('User', {
        pattern = 'CodeCompanionRequestStarted',
        group = g,
        callback = function(e)
            -- Add request to tracking table
            codecompanion_status.active_requests[e.data.id] = {
                adapter = e.data.adapter.formatted_name,
                model = e.data.adapter.model,
                strategy = e.data.strategy,
            }

            codecompanion_status.count = codecompanion_status.count + 1

            vim.cmd('redrawstatus')
        end,
    })

    cmd('User', {
        pattern = 'CodeCompanionRequestFinished',
        group = g,
        callback = function(e)
            if codecompanion_status.active_requests[e.data.id] then
                codecompanion_status.active_requests[e.data.id] = nil
                codecompanion_status.count = codecompanion_status.count - 1

                vim.cmd('redrawstatus')
            end
        end,
    })
end)

set({ 'n', 'x' }, '<Leader>cc', '<Cmd>CodeCompanionChat Toggle<CR>', { desc = 'Toggle AI chat' })
set('x', 'ga', ':CodeCompanionChat Add<CR>', { desc = 'Add to AI chat' })

Utils.Abbr('cc', 'CodeCompanion')
Utils.Abbr('ccc', 'CodeCompanionChat Toggle')
