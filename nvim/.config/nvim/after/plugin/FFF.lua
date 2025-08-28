MiniDeps.add({ source = 'dmtrKovalenko/fff.nvim', hooks = {
  post_install = Build,
  post_checkout = Build,
} })

require('fff').setup({ prompt = '🪿 ' })

vim.keymap.set('n', '<Leader>f', function() require('fff').find_files() end, { desc = 'FFFind files' })
