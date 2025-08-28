MiniDeps.add('olimorris/codecompanion.nvim')

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
            GEMINI_API_KEY = RetrieveFromEnv('GEMINI_API_KEY'),
          },
        })
      end,
    },
    http = {
      tavily = function()
        return require('codecompanion.adapters').extend('tavily', {
          env = {
            TAVILY_API_KEY = RetrieveFromEnv('TAVILY_API_KEY'),
          },
        })
      end,
    },
  },
})

vim.keymap.set({ 'n', 'v' }, '<Leader>ca', ':CodeCompanionActions<cr>')
vim.keymap.set({ 'n', 'v' }, '<Leader>cc', ':CodeCompanionChat Toggle<cr>')
vim.keymap.set('v', 'ga', ':CodeCompanionChat Add<cr>')
