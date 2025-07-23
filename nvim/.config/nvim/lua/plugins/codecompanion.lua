local H = {}

MiniDeps.later(function()
  MiniDeps.add('olimorris/codecompanion.nvim')

  require('codecompanion').setup({
    strategies = {
      chat = {
        adapter = 'venice',
        keymaps = { completion = { modes = { i = '<C-n>' } } },
        slash_commands = {
          file = { opts = { provider = 'fzf_lua' } },
          buffer = { opts = { provider = 'fzf_lua' } },
        },
      },
    },
    adapters = {
      openai = function()
        return require('codecompanion.adapters').extend('openai', {
          env = { api_key = H.retrieve_llm_key('OPENAI_API_KEY') },
          schema = { model = { default = 'gpt-4.1' } },
        })
      end,
      deepseek = function()
        return require('codecompanion.adapters').extend('deepseek', {
          env = { api_key = H.retrieve_llm_key('DEEPSEEK_API_KEY') },
          schema = { model = { default = 'deepseek-chat' } },
        })
      end,
      xai = function()
        return require('codecompanion.adapters').extend('xai', {
          env = { api_key = H.retrieve_llm_key('XAI_API_KEY') },
          schema = { model = { default = 'grok-4-0709' } },
        })
      end,
      venice = function()
        return require('codecompanion.adapters').extend('openai_compatible', {
          name = 'venice',
          formatted_name = 'Venice',
          env = {
            url = 'https://api.venice.ai/api',
            chat_url = '/v1/chat/completions',
            api_key = H.retrieve_llm_key('VENICE_API_KEY'),
          },
          schema = {
            model = {
              -- default = 'qwen3-235b',
              default = 'deepseek-r1-671b',
            },
          },
        })
      end,
    },
  })

  vim.keymap.set({ 'n', 'v' }, '<Leader>cc', '<Cmd>CodeCompanionChat Toggle<CR>', { desc = 'Toggle' })
  vim.keymap.set('v', 'ga', ':CodeCompanionChat Add<CR>', { desc = 'Add to chat' })
end)

---
--- Helpers
---

function H.retrieve_llm_key(key_name)
  local filepath = NVIM_DIR .. '/.env'
  local file = io.open(filepath, 'r')

  if not file then return nil end

  for line in file:lines() do
    line = line:match('^%s*(.-)%s*$')

    if line ~= '' and not line:match('^#') then
      local eq_pos = line:find('=')

      if eq_pos then
        local current_key = line:sub(1, eq_pos - 1)
        local current_value = line:sub(eq_pos + 1)

        current_key = current_key:match('^%s*(.-)%s*$')
        current_value = current_value:match('^%s*(.-)%s*$')

        if current_key == key_name then
          file:close()
          return current_value
        end
      end
    end
  end

  file:close()

  return nil
end
