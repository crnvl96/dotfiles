require('fff').setup({ prompt = '🪿 ' })

vim.keymap.set('n', '<Leader>f', function() require('fff').find_files() end, { desc = 'Find files' })
