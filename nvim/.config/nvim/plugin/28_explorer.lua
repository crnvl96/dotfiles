Add('stevearc/oil.nvim')

local detail = false
require('oil').setup({
    delete_to_trash = true,
    watch_for_changes = true,
    use_default_keymaps = false,
    keymaps = {
        ['g?'] = { 'actions.show_help', mode = 'n' },
        ['<CR>'] = 'actions.select',
        ['<C-w>v'] = { 'actions.select', opts = { vertical = true } },
        ['<C-w>s'] = { 'actions.select', opts = { horizontal = true } },
        ['<C-w>t'] = { 'actions.select', opts = { tab = true } },
        ['<C-w>p'] = 'actions.preview',
        ['<C-c>'] = { 'actions.close', mode = 'n' },
        ['<C-w>r'] = 'actions.refresh',
        ['-'] = { 'actions.parent', mode = 'n' },
        ['g_'] = { 'actions.open_cwd', mode = 'n' },
        ['g-'] = { 'actions.cd', mode = 'n' },
        ['g,'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
        ['gs'] = { 'actions.change_sort', mode = 'n' },
        ['gx'] = 'actions.open_external',
        ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
        ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
        ['gd'] = {
            desc = 'Toggle file detail view',
            callback = function()
                detail = not detail
                if detail then
                    require('oil').set_columns({ 'icon', 'permissions', 'size', 'mtime' })
                else
                    require('oil').set_columns({ 'icon' })
                end
            end,
        },
    },
})
