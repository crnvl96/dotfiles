Utils.Group('crnvl96-codecompanion-fidget-integration', function(g)
    local handlers = {}
    local progress = require('fidget.progress')

    vim.api.nvim_create_autocmd('User', {
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

    vim.api.nvim_create_autocmd('User', {
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
