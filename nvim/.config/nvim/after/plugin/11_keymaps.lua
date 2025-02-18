local function minifiles_explorer()
    local bufname = vim.api.nvim_buf_get_name(0)
    local path = vim.fn.fnamemodify(bufname, ':p')
    if path and vim.uv.fs_stat(path) then require('mini.files').open(bufname, false) end
end

vim.keymap.set({ 'n', 'x' }, '<C-a>', '<Cmd>CodeCompanionActions<CR>', { desc = 'Actions' })
vim.keymap.set('v', 'ga', ':CodeCompanionChat Add<CR>', { desc = 'Add to chat' })
vim.keymap.set({ 'n', 'x' }, '<Leader>a', '<Cmd>CodeCompanionChat Toggle<CR>', { desc = 'Toggle' })

vim.keymap.set('n', '<Leader>/', function() Snacks.picker.lines() end, { desc = 'Lines' })
vim.keymap.set('n', '<Leader>b', function() Snacks.picker.buffers() end, { desc = 'Buffers' })
vim.keymap.set('n', '<Leader>c', function() Snacks.picker.resume() end, { desc = 'Resume' })
vim.keymap.set('n', '<Leader>f', function() Snacks.picker.files({ hidden = true }) end, { desc = 'Files' })
vim.keymap.set({ 'n', 'x' }, '<Leader>G', function() Snacks.picker.grep_word() end, { desc = 'Grep Word' })
vim.keymap.set('n', '<Leader>g', function() Snacks.picker.grep({ hidden = true }) end, { desc = 'Grep' })
vim.keymap.set('n', '<Leader>h', function() Snacks.picker.help() end, { desc = 'Help' })
vim.keymap.set('n', '<Leader>k', function() Snacks.picker.keymaps() end, { desc = 'Keymaps' })
vim.keymap.set('n', '<Leader>p', function() Snacks.picker.pickers() end, { desc = 'Pickers' })

vim.keymap.set('n', '<Leader>d', '<Cmd>Gvdiffsplit!<CR>', { desc = 'Diff' })
vim.keymap.set('n', '<Leader>o', function() require('mini.diff').toggle_overlay() end, { desc = 'Overlay' })
vim.keymap.set('n', '<Leader>e', minifiles_explorer, { desc = 'File explorer' })
vim.keymap.set('n', '<Leader>n', '<Cmd>Neogen<CR>', { desc = 'Neogen' })

local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move)
vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_opposite)

-- vim.keymap.del('x', 'ys')
-- vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
-- vim.keymap.set('n', 'yss', 'ys_', { remap = true })

vim.keymap.set(
    'n',
    'ghy',
    function() return MiniDiff.operator('yank') .. 'gh' end,
    { expr = true, remap = true, desc = "Copy hunk's reference lines" }
)

local remap = function(mode, lhs_from, lhs_to)
    local keymap = vim.fn.maparg(lhs_from, mode, false, true)
    local rhs = keymap.callback or keymap.rhs
    if rhs == nil then error('Could not remap from ' .. lhs_from .. ' to ' .. lhs_to) end
    vim.keymap.set(mode, lhs_to, rhs, { desc = keymap.desc })
end

remap('n', 'gx', '<Leader>ox')
remap('x', 'gx', '<Leader>ox')
