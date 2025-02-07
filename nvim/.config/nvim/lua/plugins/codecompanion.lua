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

local K = Utils.Keymap

K('Actions', { mode = { 'n', 'v' }, lhs = '<C-a>', rhs = '<Cmd>CodeCompanionActions<CR>' })
K('Toggle', { mode = { 'n', 'v' }, lhs = '<Leader>a', rhs = '<Cmd>CodeCompanionChat Toggle<CR>' })
K('Add to chat', { mode = 'v', lhs = 'ga', rhs = ':CodeCompanionChat Add<CR>' })
