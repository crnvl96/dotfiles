local function retrieve_llm_key(key_name)
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

-- [X] anthropic
-- [X] xai
-- [ ] openai
-- [ ] deepseek
-- [ ] venice

MiniDeps.later(function()
  local function build_mcp(params)
    vim.notify('Building mcphub.nvim', vim.log.levels.INFO)

    local obj = vim.system({ 'npm', 'install', '-g', 'mcp-hub@latest' }, { cwd = params.path }):wait()

    if obj.code == 0 then
      vim.notify('Building mcphub.nvim done', vim.log.levels.INFO)
    else
      vim.notify('Building mcphub.nvim failed', vim.log.levels.ERROR)
    end
  end

  MiniDeps.add({
    source = 'ravitemer/mcphub.nvim',
    hooks = {
      post_install = build_mcp,
      post_checkout = build_mcp,
    },
  })

  MiniDeps.add('olimorris/codecompanion.nvim')

  require('mcphub').setup({
    config = vim.fn.expand(NVIM_DIR .. '/mcp-servers.json'),
  })

  require('codecompanion').setup({
    extensions = {
      mcphub = {
        callback = 'mcphub.extensions.codecompanion',
        opts = {
          show_result_in_chat = true,
          make_vars = true,
          make_slash_commands = true,
        },
      },
    },
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
          env = { api_key = retrieve_llm_key('OPENAI_API_KEY') },
          schema = { model = { default = 'gpt-4.1' } },
        })
      end,
      anthropic = function()
        return require('codecompanion.adapters').extend('anthropic', {
          env = {
            api_key = retrieve_llm_key('ANTHROPIC_API_KEY'),
          },
          schema = {
            model = {
              default = 'claude-sonnet-4-20250514',
            },
          },
        })
      end,
      gemini = function()
        return require('codecompanion.adapters').extend('gemini', {
          env = { api_key = retrieve_llm_key('GEMINI_API_KEY') },
          schema = { model = { default = 'gemini-2.5-pro-preview-05-06' } },
        })
      end,
      deepseek = function()
        return require('codecompanion.adapters').extend('deepseek', {
          env = {
            api_key = retrieve_llm_key('DEEPSEEK_API_KEY'),
          },
          schema = {
            model = {
              default = 'deepseek-chat',
            },
          },
        })
      end,
      xai = function()
        return require('codecompanion.adapters').extend('xai', {
          env = {
            api_key = retrieve_llm_key('XAI_API_KEY'),
          },
          schema = {
            model = {
              default = 'grok-4-0709',
            },
          },
        })
      end,
      venice = function()
        return require('codecompanion.adapters').extend('openai_compatible', {
          name = 'venice',
          formatted_name = 'Venice',
          env = {
            url = 'https://api.venice.ai/api',
            chat_url = '/v1/chat/completions',
            api_key = retrieve_llm_key('VENICE_API_KEY'),
          },
          schema = {
            model = {
              default = 'deepseek-r1-671b',
              -- default = 'qwen3-235b',
            },
            temperature = {
              order = 2,
              mapping = 'parameters',
              type = 'number',
              optional = true,
              default = 0.8,
              desc = 'What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.',
              validate = function(n) return n >= 0 and n <= 2, 'Must be between 0 and 2' end,
            },
            max_completion_tokens = {
              order = 3,
              mapping = 'parameters',
              type = 'integer',
              optional = true,
              default = nil,
              desc = 'An upper bound for the number of tokens that can be generated for a completion.',
              validate = function(n) return n > 0, 'Must be greater than 0' end,
            },
            presence_penalty = {
              order = 4,
              mapping = 'parameters',
              type = 'number',
              optional = true,
              default = 0,
              desc = "Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics.",
              validate = function(n) return n >= -2 and n <= 2, 'Must be between -2 and 2' end,
            },
            top_p = {
              order = 5,
              mapping = 'parameters',
              type = 'number',
              optional = true,
              default = 0.9,
              desc = 'A higher value (e.g., 0.95) will lead to more diverse text, while a lower value (e.g., 0.5) will generate more focused and conservative text. (Default: 0.9)',
              validate = function(n) return n >= 0 and n <= 1, 'Must be between 0 and 1' end,
            },
            stop = {
              order = 6,
              mapping = 'parameters',
              type = 'string',
              optional = true,
              default = nil,
              desc = 'Sets the stop sequences to use. When this pattern is encountered the LLM will stop generating text and return. Multiple stop patterns may be set by specifying multiple separate stop parameters in a modelfile.',
              validate = function(s) return s:len() > 0, 'Cannot be an empty string' end,
            },
            frequency_penalty = {
              order = 8,
              mapping = 'parameters',
              type = 'number',
              optional = true,
              default = 0,
              desc = "Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim.",
              validate = function(n) return n >= -2 and n <= 2, 'Must be between -2 and 2' end,
            },
            logit_bias = {
              order = 9,
              mapping = 'parameters',
              type = 'map',
              optional = true,
              default = nil,
              desc = 'Modify the likelihood of specified tokens appearing in the completion. Maps tokens (specified by their token ID) to an associated bias value from -100 to 100. Use https://platform.openai.com/tokenizer to find token IDs.',
              subtype_key = {
                type = 'integer',
              },
              subtype = {
                type = 'integer',
                validate = function(n) return n >= -100 and n <= 100, 'Must be between -100 and 100' end,
              },
            },
          },
          roles = {
            llm = 'assistant',
            user = 'user',
          },
          opts = {
            stream = true,
          },
          features = {
            text = true,
            tokens = true,
            vision = false,
          },
        })
      end,
    },
  })

  vim.keymap.set({ 'n', 'v' }, '<Leader>ca', '<cmd>CodeCompanionActions<cr>')
  vim.keymap.set({ 'n', 'v' }, '<Leader>cc', '<cmd>CodeCompanionChat Toggle<cr>')
  vim.keymap.set('v', 'ga', '<cmd>CodeCompanionChat Add<cr>')
end)
