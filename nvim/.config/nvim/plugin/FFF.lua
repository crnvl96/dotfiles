MiniDeps.add({
  source = 'dmtrKovalenko/fff.nvim',
  hooks = {
    post_install = function(params) Build(params, 'cargo +nightly build --release') end,
    post_checkout = function(params) Build(params, 'cargo +nightly build --release') end,
  },
})

require('fff').setup({ prompt = '🪿 ' })

vim.keymap.set('n', '<Leader>f', function() require('fff').find_files() end, { desc = 'FFFind files' })
