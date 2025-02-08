-- https://github.com/olimorris/codecompanion.nvim/tree/main/lua/codecompanion/adapters
-- available huggingface models can be found at https://huggingface.co/models?inference=warm&pipeline_tag=text-generation
vim.g.codecompanion_adapter = 'anthropic'

Add('olimorris/codecompanion.nvim')

require('codecompanion').setup({
  strategies = {
    chat = {
      adapter = vim.g.codecompanion_adapter,
      keymaps = {
        completion = {
          modes = {
            i = '<C-n>',
          },
        },
      },
    },
    inline = { adapter = vim.g.codecompanion_adapter },
    cmd = { adapter = vim.g.codecompanion_adapter },
  },
  adapters = {
    huggingface = require('codecompanion.adapters').extend('huggingface', {
      env = { api_key = Utils.ReadFromFile('huggingface') },
      schema = {
        model = {
          default = 'deepseek-ai/DeepSeek-R1-Distill-Qwen-32B',
        },
      },
    }),
    anthropic = require('codecompanion.adapters').extend('anthropic', {
      env = { api_key = Utils.ReadFromFile('anthropic') },
      schema = {
        model = {
          default = 'claude-3-5-sonnet-20241022',
        },
      },
    }),
    deepseek = require('codecompanion.adapters').extend('deepseek', {
      env = { api_key = Utils.ReadFromFile('deepseek') },
      schema = {
        model = {
          default = 'deepseek-reasoner',
        },
      },
    }),
  },
})

vim.keymap.set({ 'n', 'v' }, '<C-a>', '<Cmd>CodeCompanionActions<CR>', { desc = 'Actions' })
vim.keymap.set({ 'n', 'v' }, '<Leader>a', '<Cmd>CodeCompanionChat Toggle<CR>', { desc = 'Toggle' })
vim.keymap.set('v', 'ga', ':CodeCompanionChat Add<CR>', { desc = 'Add to chat' })
