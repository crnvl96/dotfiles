local deck = require('deck')
local builtin_decorators = deck.get_decorators()

require('deck.easy').setup()

deck.register_action({
    name = 'send_to_qf',
    resolve = function(ctx) return #ctx.get_action_items() >= 1 and ctx.get_action_items()[1].data.filename end,
    execute = function(ctx)
        local selected_items = ctx.get_selected_items()
        local qf_list = {}

        for _, item in ipairs(selected_items) do
            local data = item.data
            table.insert(qf_list, {
                filename = data.filename,
                lnum = data.lnum or 1,
                col = data.col or 1,
                text = item.display_text or '',
            })
        end

        ctx.hide()
        vim.fn.setqflist(qf_list, 'r')
        vim.cmd('copen')
    end,
})

Utils.Group('crnvl96-deck-setup', function(g)
    vim.api.nvim_create_autocmd('User', {
        pattern = 'DeckStart',
        group = g,
        callback = function(e)
            local ctx = e.data.ctx

            ctx.keymap('n', '<Tab>', deck.action_mapping('choose_action'))
            ctx.keymap('n', '<C-l>', deck.action_mapping('refresh'))
            ctx.keymap('n', 'i', deck.action_mapping('prompt'))
            ctx.keymap('n', 'a', deck.action_mapping('prompt'))
            ctx.keymap('n', '@', deck.action_mapping('toggle_select'))
            ctx.keymap('n', '*', deck.action_mapping('toggle_select_all'))
            ctx.keymap('n', 'p', deck.action_mapping('toggle_preview_mode'))
            ctx.keymap('n', 'd', deck.action_mapping('delete'))
            ctx.keymap('n', '<CR>', deck.action_mapping('default'))
            ctx.keymap('n', 'o', deck.action_mapping('open'))
            ctx.keymap('n', 'O', deck.action_mapping('open_keep'))
            ctx.keymap('n', 's', deck.action_mapping('open_split'))
            ctx.keymap('n', 'v', deck.action_mapping('open_vsplit'))
            ctx.keymap('n', 'N', deck.action_mapping('create'))
            ctx.keymap('n', 'w', deck.action_mapping('write'))
            ctx.keymap('n', '<C-u>', deck.action_mapping('scroll_preview_up'))
            ctx.keymap('n', '<C-d>', deck.action_mapping('scroll_preview_down'))
            ctx.keymap('n', '<C-q>', deck.action_mapping('send_to_qf'))
        end,
    })

    vim.api.nvim_create_autocmd('User', {
        pattern = 'DeckStart:explorer',
        group = g,
        callback = function(e)
            local ctx = e.data.ctx
            ctx.keymap('n', 'h', deck.action_mapping('explorer.collapse'))
            ctx.keymap('n', 'l', deck.action_mapping('explorer.expand'))
            ctx.keymap('n', '.', deck.action_mapping('explorer.toggle_dotfiles'))
            ctx.keymap('n', 'c', deck.action_mapping('explorer.clipboard.save_copy'))
            ctx.keymap('n', 'm', deck.action_mapping('explorer.clipboard.save_move'))
            ctx.keymap('n', 'p', deck.action_mapping('explorer.clipboard.paste'))
            ctx.keymap('n', 'x', deck.action_mapping('explorer.clipboard.paste'))
            ctx.keymap('n', 'a', deck.action_mapping('explorer.create'))
            ctx.keymap('n', 'd', deck.action_mapping('explorer.delete'))
            ctx.keymap('n', 'r', deck.action_mapping('explorer.rename'))

            ctx.keymap('n', '<Leader>ff', deck.action_mapping('explorer.dirs'))

            ctx.keymap('n', 'P', deck.action_mapping('toggle_preview_mode'))
            ctx.keymap('n', '~', function() ctx.do_action('explorer.get_api').set_cwd(vim.fs.normalize('~')) end)
            ctx.keymap('n', '\\', function() ctx.do_action('explorer.get_api').set_cwd(vim.fs.normalize('/')) end)
            ctx.keymap('n', '%', function()
                local alt_buf = vim.fn.bufnr('#')
                local bufname = vim.fn.bufname(alt_buf)
                local bufdir = vim.fn.fnamemodify(bufname, ':p:h')
                ctx.do_action('explorer.get_api').set_cwd(bufdir)
            end)

            ctx.keymap('n', '<C-l>', function() vim.cmd('wincmd l') end)
            ctx.keymap('n', '-', function() vim.cmd('wincmd c') end)
        end,
    })
end)

vim.ui.select = function(items, opts, on_choice)
    local function to_str(item)
        item = Utils.ExpandCallable(item)
        if type(item) == 'string' then return item end
        if type(item) == 'table' and type(item.text) == 'string' then return item.text end
        return vim.inspect(item, { newline = ' ', indent = '' })
    end

    local formatter = opts.format_item or to_str

    local previewer = vim.is_callable(opts.preview_item) and opts.preview_item
        or function(x) return vim.split(vim.inspect(x), '\n') end

    local ui_select_option_list = {}

    for i = 1, #items do
        table.insert(ui_select_option_list, { text = formatter(items[i]), item = items[i], index = i })
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
                        local i_data = ctx.get_action_items()[1].data.item
                        on_choice(items[i_data.index], i_data.index)
                        ctx.hide()
                    end

                    for _, i in ipairs(sel_items) do
                        local i_data = i.data.item
                        on_choice(items[i_data.index], i_data.index)
                    end

                    ctx.hide()
                end,
            },
        },
        previewers = {
            {
                name = 'ui_select_text',
                resolve = function(_, item) return item.data.item.item end,
                preview = function(_, item, env) Utils.SetBufLines(vim.fn.winbufnr(env.win), previewer(item.data.item)) end,
            },
        },
        decorators = {
            builtin_decorators.filename,
            -- builtin_decorators.query_matches,
            -- builtin_decorators.highlights,
        },
    })

    if item == nil then on_choice(nil) end
end

local set = vim.keymap.set

set('n', '-', '<Cmd>Deck explorer<CR>', { desc = 'File Explorer' })
set('n', '<Leader>,', '<Cmd>Deck buffers<CR>', { desc = 'Buffers picker' })
set('n', '<Leader>fh', '<Cmd>Deck helpgrep<CR>', { desc = 'Help' })
set('n', '<Leader>fl', '<Cmd>Deck lines<CR>', { desc = 'Lines' })

set(
    'n',
    '<Leader>ff',
    function()
        deck.start(require('deck.builtin.source.files')({
            root_dir = vim.uv.cwd(),
        }))
    end,
    { desc = 'Files' }
)

set(
    'n',
    '<Leader>fg',
    function()
        deck.start(require('deck.builtin.source.grep')({
            root_dir = vim.uv.cwd(),
        }))
    end,
    { desc = 'Grep' }
)

set('n', '<Leader>fr', function()
    local context = deck.get_history()[vim.v.count == 0 and 1 or vim.v.count]
    if context then context.show() end
end)
