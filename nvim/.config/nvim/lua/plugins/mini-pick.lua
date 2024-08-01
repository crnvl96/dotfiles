require('mini.visits').setup()

local win_config = function()
  local height = math.floor(0.618 * vim.o.lines)
  local width = math.floor(0.962 * vim.o.columns)
  return {
    height = height,
    width = width,
  }
end

require('mini.pick').setup({
  options = {
    use_cache = true,
  },
  window = {
    config = win_config,
    prompt_cursor = '█',
    prompt_prefix = '',
  },
})

vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<cr>', { desc = 'Files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Pick grep_live<cr>', { desc = 'Grep' })
vim.keymap.set('n', '<leader>fo', '<cmd>Pick oldfiles<cr>', { desc = 'Oldfiles' })
vim.keymap.set('n', '<leader>fm', '<cmd>Pick marks<cr>', { desc = 'Marks' })
