local ui_select = require('fzf-lua.providers.ui_select')
local fzflua = require('fzf-lua')
local set = vim.keymap.set

local function action_noop(_, opts)
    local o = vim.tbl_deep_extend('keep', { resume = true }, opts.__call_opts)
    opts.__call_fn(o)
end

vim.ui.select = function(items, opts, on_choice)
    if not ui_select.is_registered() then ui_select.register() end
    if #items > 0 then return vim.ui.select(items, opts, on_choice) end
end

fzflua.setup({
    { 'ivy', 'hide' },
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
    actions = {
        files = {
            true,
            ['ctrl-g'] = { action_noop },
        },
    },
})

set('n', '<Leader>f,', function() fzflua.buffers() end, { desc = 'Find files (FZF)' })
set('n', '<Leader>ff', function() fzflua.files() end, { desc = 'Find files (FZF)' })
set('n', '<Leader>fg', function() fzflua.live_grep() end, { desc = 'Grep files (FZF)' })
set('x', '<Leader>fg', function() fzflua.grep_visual() end, { desc = 'Grep visual (FZF)' })
set('n', '<Leader>fo', function() fzflua.oldfiles() end, { desc = 'Find oldfiles (FZF)' })
set('n', '<Leader>fl', function() fzflua.blines() end, { desc = 'Find lines (FZF)' })
set('n', '<Leader>fh', function() fzflua.helptags() end, { desc = 'Find helptags (FZF)' })
set('n', '<Leader>fH', function() fzflua.highlights() end, { desc = 'Find highlights (FZF)' })
set('n', '<Leader>fk', function() fzflua.keymaps() end, { desc = 'Find keymaps (FZF)' })
set('n', '<Leader>fr', function() fzflua.resume() end, { desc = 'Resume last finder (FZF)' })
set('n', '<Leader>fx', function() fzflua.quickfix() end, { desc = 'Quickfix (FZF)' })
