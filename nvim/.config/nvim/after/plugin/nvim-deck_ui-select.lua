local deck = require('deck')
local Async = require('deck.kit.Async')

---Expand a callable value or return the value itself
---@param x any Value or callable
---@param ... any Arguments to pass to the callable
---@return any
local expand_callable = function(x, ...)
    if vim.is_callable(x) then return x(...) end
    return x
end

---Set buffer lines
---@param buf_id number Buffer number
---@param lines string[] Lines to set
local set_buf_lines = function(buf_id, lines) pcall(vim.api.nvim_buf_set_lines, buf_id, 0, -1, false, lines) end

---Convert an item to a string representation
---@param item any
---@return string
local function item_to_string(item)
    item = expand_callable(item)
    if type(item) == 'string' then return item end
    if type(item) == 'table' and type(item.text) == 'string' then return item.text end
    return vim.inspect(item, { newline = ' ', indent = '' })
end

---Create a default previewer function
---@param item any
---@return string[]
local function default_previewer(item) return vim.split(vim.inspect(item), '\n') end

---UI select implementation using deck
---@param items table Items to select from
---@param opts table Options for the selection
---@param on_choice function Callback function
vim.ui.select = function(items, opts, on_choice)
    -- Early validation
    if not items or type(items) ~= 'table' then
        vim.schedule(function() on_choice(nil) end)
        return
    end

    opts = opts or {}
    local formatter = opts.format_item or item_to_string
    local previewer = vim.is_callable(opts.preview_item) and opts.preview_item or default_previewer

    -- Process items asynchronously for large lists
    Async.run(function()
        local ui_select_option_list = {}

        -- Process items in chunks to avoid blocking UI
        for i = 1, #items do
            table.insert(ui_select_option_list, {
                text = formatter(items[i]),
                item = items[i],
                index = i,
            })

            -- Yield periodically to keep UI responsive for large lists
            if i % 500 == 0 then Async.interrupt(10) end
        end

        local item = deck.start({
            name = 'Deck UI Select',
            execute = function(ctx)
                for _, i in ipairs(ui_select_option_list) do
                    ctx.item({
                        display_text = i.text,
                        data = { item = i, filename = i.text },
                    })
                end
                ctx.done()
            end,
            actions = {
                {
                    name = 'default',
                    execute = function(ctx)
                        local sel_items = ctx.get_selected_items()

                        if #sel_items < 1 then
                            -- Handle case when no item is explicitly selected
                            local action_items = ctx.get_action_items()
                            if #action_items > 0 then
                                local i_data = action_items[1].data.item
                                on_choice(items[i_data.index], i_data.index)
                            else
                                on_choice(nil)
                            end
                        else
                            -- Handle selected items
                            for _, i in ipairs(sel_items) do
                                local i_data = i.data.item
                                on_choice(items[i_data.index], i_data.index)
                            end
                        end

                        ctx.hide()
                    end,
                },
                {
                    name = 'cancel',
                    execute = function(ctx)
                        on_choice(nil)
                        ctx.hide()
                    end,
                },
            },
            previewers = {
                {
                    name = 'ui_select_text',
                    resolve = function(_, item) return item.data.item.item end,
                    preview = function(_, item, env)
                        if not env.win or not vim.api.nvim_win_is_valid(env.win) then return end
                        local bufnr = vim.fn.winbufnr(env.win)
                        local preview_content = previewer(item.data.item.item)
                        set_buf_lines(bufnr, preview_content)
                    end,
                },
            },
            decorators = {
                deck.get_decorators().filename,
            },
        })

        if item == nil then on_choice(nil) end
    end)
end
