require('snacks').setup({
    input = {
        enabled = true,
    },
    picker = {
        layout = {
            preset = 'ivy',
        },
        sources = {
            files = {
                hidden = true,
            },
            explorer = {
                hidden = true,
                layout = {
                    layout = {
                        position = 'right',
                        width = 80,
                    },
                },
            },
        },
    },
})

local set = vim.keymap.set

set('n', '-', function() Snacks.explorer() end, { desc = 'File Explorer' })
set('n', '<leader>,', function() Snacks.picker.buffers() end, { desc = 'Buffers' })
set('n', '<leader>ff', function() Snacks.picker.files() end, { desc = 'Find Files' })
set('n', '<leader>fo', function() Snacks.picker.recent() end, { desc = 'Recent' })
set('n', '<leader>fl', function() Snacks.picker.lines() end, { desc = 'Buffer Lines' })
set('n', '<leader>fg', function() Snacks.picker.grep() end, { desc = 'Grep' })
set({ 'n', 'x' }, '<leader>fG', function() Snacks.picker.grep_word() end, { desc = 'Visual selection or word' })
set('n', '<leader>lE', function() Snacks.picker.diagnostics() end, { desc = 'Diagnostics' })
set('n', '<leader>le', function() Snacks.picker.diagnostics_buffer() end, { desc = 'Buffer Diagnostics' })
set('n', '<leader>fh', function() Snacks.picker.help() end, { desc = 'Help Pages' })
set('n', '<leader>fH', function() Snacks.picker.highlights() end, { desc = 'Highlights' })
set('n', '<leader>fk', function() Snacks.picker.keymaps() end, { desc = 'Keymaps' })
set('n', '<leader>fr', function() Snacks.picker.resume() end, { desc = 'Resume' })

set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = 'Goto Definition' })
set('n', 'gD', function() Snacks.picker.lsp_declarations() end, { desc = 'Goto Declaration' })
set('n', 'gr', function() Snacks.picker.lsp_references() end, { nowait = true, desc = 'References' })
set('n', 'gi', function() Snacks.picker.lsp_implementations() end, { desc = 'Goto Implementation' })
set('n', 'gy', function() Snacks.picker.lsp_type_definitions() end, { desc = 'Goto T[y]pe Definition' })

set('n', '<leader>ls', function() Snacks.picker.lsp_symbols() end, { desc = 'LSP Symbols' })
set('n', '<leader>lS', function() Snacks.picker.lsp_workspace_symbols() end, { desc = 'LSP Workspace Symbols' })
