Add('tpope/vim-fugitive')

local K = Utils.Keymap

K('Open', { lhs = '<Leader>gg', mode = 'n', rhs = '<Cmd>Git<CR>' })
K('Diff', { lhs = '<Leader>gd', mode = 'n', rhs = '<Cmd>Gvdiffsplit!<CR>' })
K('Commit', { lhs = '<Leader>gc', mode = 'n', rhs = '<Cmd>Git commit<CR>' })
K('Amend', { lhs = '<Leader>gC', mode = 'n', rhs = '<Cmd>Git commit --amend<CR>' })
K('Push', { lhs = '<Leader>gp', mode = 'n', rhs = '<Cmd>Git push<CR>' })
K('Force push', { lhs = '<Leader>gP', mode = 'n', rhs = '<Cmd>Git push --force-with-lease<CR>' })
