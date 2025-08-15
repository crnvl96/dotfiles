MiniDeps.later(function()
  require('mini.pick').setup({
    mappings = {
      caret_left = '<M-h>',
      caret_right = '<M-l>',
    },
    options = {
      use_cache = true,
    },
    window = {
      prompt_caret = '▏',
      prompt_prefix = ' ',
      config = {
        relative = 'cursor',
        anchor = 'NW',
        row = 0,
        col = 0,
        width = 80,
        height = 30,
      },
    },
  })

  vim.ui.select = require('mini.pick').ui_select

  vim.keymap.set('n', '<Leader>f', '<Cmd>Pick files<CR>', { desc = 'Find files' })
  vim.keymap.set('n', '<C-6>', '<Cmd>Pick buffers<CR>', { desc = 'Find files' })

  local function list_bufs()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, true, true), 't', true)
    require('mini.pick').builtin.buffers()
  end

  vim.keymap.set('t', '<C-6>', list_bufs, { desc = 'List buffers' })
end)
