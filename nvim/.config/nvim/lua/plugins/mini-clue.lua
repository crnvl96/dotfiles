local b = require('utils.builtin')

require('mini.clue').setup({
  triggers = {
    -- Builtins.
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = '`' },
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },
    { mode = 'n', keys = '<C-w>' },
    { mode = 'i', keys = '<C-x>' },
    { mode = 'n', keys = 'z' },
    -- Leader triggers.
    { mode = 'n', keys = '<leader>' },
    { mode = 'x', keys = '<leader>' },
    -- Moving between stuff.
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
  },
  clues = {
    -- Leader/movement groups.
    { mode = 'n', keys = '<leader>c', desc = '+Codecompanion' },
    { mode = 'x', keys = '<leader>c', desc = '+Codecompanion' },
    { mode = 'n', keys = '[', desc = '+prev' },
    { mode = 'n', keys = ']', desc = '+next' },
    -- Builtins.
    require('mini.clue').gen_clues.builtin_completion(),
    require('mini.clue').gen_clues.g(),
    require('mini.clue').gen_clues.marks(),
    require('mini.clue').gen_clues.registers(),
    require('mini.clue').gen_clues.windows(),
    require('mini.clue').gen_clues.z(),
  },
  window = {
    delay = 500,
    scroll_down = '<C-f>',
    scroll_up = '<C-b>',
    config = {
      width = 'auto',
    },
  },
})

for _, hl in ipairs({
  'MiniClueBorder',
  'MiniClueDescGroup',
  'MiniClueDescSingle',
  'MiniClueNextKey',
  'MiniClueNextKeyWithPostkeys',
  'MiniClueSeparator',
  'MiniClueTitle',
}) do
  b.override_highlight(hl, { bg = 'none' })
end
