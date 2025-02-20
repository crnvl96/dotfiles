Utils.Group('crnvl96-codecompanion-fidget-integration', function(g)
    local progress = require('fidget.progress')
    local handlers = {}

    vim.api.nvim_create_autocmd({ 'User' }, {
        pattern = 'CodeCompanionRequestStarted',
        group = g,
        callback = function(e)
            local function title(adapter)
                local parts = {}
                table.insert(parts, adapter.formatted_name)
                if adapter.model and adapter.model ~= '' then table.insert(parts, '(' .. adapter.model .. ')') end
                return table.concat(parts, ' ')
            end

            handlers[e.data.id] = progress.handle.create({
                title = ' Requesting assistance (' .. e.data.strategy .. ')',
                message = 'In progress...',
                lsp_client = { name = title(e.data.adapter) },
            })
        end,
    })

    vim.api.nvim_create_autocmd({ 'User' }, {
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
