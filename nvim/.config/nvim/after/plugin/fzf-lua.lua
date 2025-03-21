local ui_select = require('fzf-lua.providers.ui_select')
local fzflua = require('fzf-lua')
local set = vim.keymap.set

vim.ui.select = function(items, opts, on_choice)
    if not ui_select.is_registered() then ui_select.register() end
    if #items > 0 then return vim.ui.select(items, opts, on_choice) end
end

fzflua.setup({
    winopts = {
        border = 'none',
        preview = {
            layout = 'vertical',
            vertical = 'up:40%',
            border = 'none',
        },
    },
    fzf_colors = {
        bg = { 'bg', 'Normal' },
        gutter = { 'bg', 'Normal' },
        info = { 'fg', 'Conditional' },
        scrollbar = { 'bg', 'Normal' },
        separator = { 'fg', 'Comment' },
    },
    fzf_opts = {
        ['--cycle'] = '',
        ['--info'] = 'default',
        ['--layout'] = 'reverse-list',
    },
    keymap = {
        fzf = {
            ['ctrl-q'] = 'select-all+accept',
            ['ctrl-u'] = 'half-page-up',
            ['ctrl-d'] = 'half-page-down',
            ['ctrl-x'] = 'jump',
            ['ctrl-f'] = 'preview-page-down',
            ['ctrl-b'] = 'preview-page-up',
        },
        builtin = {
            ['<c-f>'] = 'preview-page-down',
            ['<c-b>'] = 'preview-page-up',
        },
    },
})

set('n', '<Leader>f', function() fzflua.files() end, { desc = 'Find files (FZF)' })
set('n', '<Leader>,', function() fzflua.buffers() end, { desc = 'Find buffers (FZF)' })
set('n', '<Leader>/', function() fzflua.live_grep() end, { desc = 'Grep files (FZF)' })
set('x', '<Leader>/', function() fzflua.grep_visual() end, { desc = 'Grep visual (FZF)' })
set('n', '<Leader>r', function() fzflua.resume() end, { desc = 'Resume last finder (FZF)' })

set('n', '<Leader>h', function() fzflua.helptags() end, { desc = 'Find helptags (FZF)' })
set('n', '<Leader>x', function() fzflua.quickfix() end, { desc = 'Quickfix (FZF)' })
set('n', '<Leader>z', '<Cmd>FzfLua<CR>', { desc = 'Menu (FZF)' })
