local f = require('utils.fs')

require('codecompanion').setup({
  strategies = {
    chat = {
      adapter = 'gemini_cli',
    },
    inline = {
      adapter = 'gemini_cli',
    },
    cmd = {
      adapter = 'gemini_cli',
    },
  },
  adapters = {
    acp = {
      gemini_cli = function()
        return require('codecompanion.adapters').extend('gemini_cli', {
          defaults = {
            mcpServers = {},
          },
          env = {
            GEMINI_API_KEY = f.retrieve_from_env('GEMINI_API_KEY'),
          },
        })
      end,
    },
    http = {
      tavily = function()
        return require('codecompanion.adapters').extend('tavily', {
          env = {
            TAVILY_API_KEY = f.retrieve_from_env('TAVILY_API_KEY'),
          },
        })
      end,
    },
  },
})

vim.keymap.set({ 'n', 'v' }, '<Leader>ca', ':CodeCompanionActions<cr>', { desc = 'Codecompanion Actions' })
vim.keymap.set({ 'n', 'v' }, '<Leader>cc', ':CodeCompanionChat Toggle<cr>', { desc = 'Codecompanion Toggle Chat' })
vim.keymap.set('v', 'ga', ':CodeCompanionChat Add<cr>', { desc = 'Add to Codecompanion Chat' })
