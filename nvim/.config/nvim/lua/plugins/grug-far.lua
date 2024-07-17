MiniDeps.add('MagicDuck/grug-far.nvim')

require('grug-far').setup({
  headerMaxWidth = 80,
  icons = { enabled = false },
})

vim.keymap.set({ 'n', 'v' }, '<leader>sr', function()
  local grug = require('grug-far')
  local file = vim.bo.buftype == '' and vim.fs.basename(vim.fn.expand('%:p'))

  grug.grug_far({
    transient = true,
    prefills = {
      filesFilter = file and file ~= '' and '**/*/' .. file or nil,
    },
  })
end, { desc = 'Search and Replace' })

vim.keymap.set({ 'n', 'v' }, '<leader>sR', function()
  local grug = require('grug-far')

  local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
  grug.grug_far({
    transient = true,
    prefills = {
      filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
    },
  })
end, { desc = 'Search and Replace' })
