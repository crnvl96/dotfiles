Utils.Group('crnvl96-snacks-minifiles-rename', function(g)
    vim.api.nvim_create_autocmd('User', {
        group = g,
        pattern = 'MiniFilesActionRename',
        callback = function(event) Snacks.rename.on_rename_file(event.data.from, event.data.to) end,
    })
end)

Utils.Group('crnvl96-mini-files', function(g)
    local function map_split(buf_id, lhs, direction)
        local minifiles = require('mini.files')

        local function rhs()
            local window = minifiles.get_explorer_state().target_window

            if window == nil or minifiles.get_fs_entry().fs_type == 'directory' then return end

            local new_target_window
            vim.api.nvim_win_call(window, function()
                vim.cmd(direction .. ' split')
                new_target_window = vim.api.nvim_get_current_win()
            end)

            minifiles.set_target_window(new_target_window)

            minifiles.go_in({ close_on_file = true })
        end

        vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = 'Split ' .. string.sub(direction, 12) })
    end

    vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesWindowOpen',
        group = g,
        callback = function(args) vim.api.nvim_win_set_config(args.data.win_id, { border = 'rounded' }) end,
    })

    vim.api.nvim_create_autocmd('User', {
        desc = 'Add minifiles split keymaps',
        group = g,
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
            local buf_id = args.data.buf_id
            map_split(buf_id, '<C-s>', 'belowright horizontal')
            map_split(buf_id, '<C-v>', 'belowright vertical')
        end,
    })
end)

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
