Add('folke/snacks.nvim')

require('snacks').setup({
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    notifier = { enabled = true },
    input = { enabled = true },
    indent = {
        indent = { enabled = false },
        scope = { enabled = false },
        chunk = { enabled = true },
    },
    gitbrowse = {
        notify = true,
        open = function(url) vim.fn.setreg('+', url) end,
    },
    picker = {
        matcher = {
            cwd_bonus = true,
            frecency = true,
            history_bonus = true,
        },
        formatters = {
            file = {
                filename_first = false,
                truncate = 120,
            },
        },
        layouts = {
            default = { preview = false },
        },
        win = {
            input = {
                keys = {
                    ['yy'] = 'copy',
                    ['<m-y>'] = { 'copy', mode = { 'n', 'i' } },
                },
            },
            list = { keys = { ['yy'] = 'copy' } },
        },
    },
})

vim.api.nvim_create_user_command('Browse', function(args)
    local line_start = nil
    local line_end = nil
    if args.count ~= -1 then
        line_start = args.line1
        line_end = args.line2
    end
    Snacks.gitbrowse({ line_start = line_start, line_end = line_end })
end, { range = true })

Utils.Group('crnvl96-snacks-minifiles-rename', function(g)
    vim.api.nvim_create_autocmd('User', {
        group = g,
        pattern = 'MiniFilesActionRename',
        callback = function(event) Snacks.rename.on_rename_file(event.data.from, event.data.to) end,
    })
end)

Later(function()
    vim.keymap.set('n', '<Leader>f', function() Snacks.picker.files({ hidden = true }) end, { desc = 'Files' })
    vim.keymap.set('n', '<Leader>b', function() Snacks.picker.buffers() end, { desc = 'Buffers' })
    vim.keymap.set('n', '<Leader>g', function() Snacks.picker.grep({ hidden = true }) end, { desc = 'Grep' })
    vim.keymap.set({ 'n', 'x' }, '<Leader>G', function() Snacks.picker.grep_word() end, { desc = 'Grep Word' })
    vim.keymap.set('n', '<Leader>h', function() Snacks.picker.help() end, { desc = 'Help' })
    vim.keymap.set('n', '<Leader>/', function() Snacks.picker.lines() end, { desc = 'Lines' })
    vim.keymap.set('n', '<Leader>c', function() Snacks.picker.resume() end, { desc = 'Resume' })
    vim.keymap.set('n', '<Leader>p', function() Snacks.picker.pickers() end, { desc = 'Pickers' })

    --- Some LSP related keymaps

    vim.keymap.set('n', 'ga', function() vim.lsp.buf.code_action() end, { desc = 'Actions' })
    vim.keymap.set('n', 'gn', function() vim.lsp.buf.rename() end, { desc = 'Rename' })
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover({ border = 'rounded' }) end, { desc = 'Eval' })
    vim.keymap.set('n', 'E', function() vim.diagnostic.open_float({ border = 'rounded' }) end, { desc = 'Eval Error' })
    vim.keymap.set('i', '<C-/>', function() vim.lsp.buf.signature_help({ border = 'rounded' }) end, { desc = 'Help' })

    vim.keymap.set('n', 'gD', function() Snacks.picker.diagnostics() end, { desc = 'Diagnostic logs' })
    vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = 'Definition' })
    vim.keymap.set('n', 'gi', function() Snacks.picker.lsp_implementations() end, { desc = 'Impl' })
    vim.keymap.set('n', 'gr', function() Snacks.picker.lsp_references() end, { desc = 'References', nowait = true })
    vim.keymap.set('n', 'gy', function() Snacks.picker.type_definitions() end, { desc = 'Typedefs' })
end)
