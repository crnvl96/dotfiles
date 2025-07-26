MiniDeps.later(function()
  local function build(params)
    vim.notify('Building mcp-hub', vim.log.levels.INFO)
    local out = vim.system({ 'npm', 'install', '-g', 'mcp-hub@latest' }, { cwd = params.path }):wait()
    if out.code == 0 then return vim.notify('Building mcp-hub done', vim.log.levels.INFO) end
    return vim.notify('Building mcp-hub failed', vim.log.levels.ERROR)
  end

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

  MiniDeps.add('HakonHarnes/img-clip.nvim')
  local hooks = { post_install = build, post_checkout = build }
  MiniDeps.add({ source = 'ravitemer/mcphub.nvim', hooks = hooks })
  MiniDeps.add('nvim-lua/plenary.nvim')
  MiniDeps.add('olimorris/codecompanion.nvim')

  require('img-clip').setup({
    filetypes = {
      codecompanion = {
        prompt_for_file_name = false,
        template = '[Image]($FILE_PATH)',
        use_absolute_path = true,
      },
    },
  })

  require('mcphub').setup({
    config = vim.fn.expand('~/.config/nvim/mcp-servers.json'),
  })

  require('codecompanion').setup({
    extensions = {
      mcphub = {
        callback = 'mcphub.extensions.codecompanion',
        opts = {
          make_vars = true,
          make_slash_commands = true,
          show_result_in_chat = true,
        },
      },
    },
    strategies = {
      chat = {
        adapter = 'openai',
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
      gemini = function()
        return require('codecompanion.adapters').extend('gemini', {
          env = { api_key = retrieve_llm_key('GEMINI_API_KEY') },
          schema = { model = { default = 'gemini-2.5-pro-preview-05-06' } },
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
      deepseek = function()
        return require('codecompanion.adapters').extend('deepseek', {
          env = { api_key = retrieve_llm_key('DEEPSEEK_API_KEY') },
          schema = { model = { default = 'deepseek-chat' } },
        })
      end,
      xai = function()
        return require('codecompanion.adapters').extend('xai', {
          env = { api_key = retrieve_llm_key('XAI_API_KEY') },
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
            api_key = retrieve_llm_key('VENICE_API_KEY'),
          },
          schema = {
            model = {
              default = 'qwen3-235b',
            },
          },
        })
      end,
    },
  })

  vim.keymap.set('n', '<Leader>cp', '<cmd>PasteImage<cr>', { desc = 'Paste image from system clipboard' })
  vim.keymap.set({ 'n', 'v' }, '<Leader>cc', '<Cmd>CodeCompanionChat Toggle<CR>', { desc = 'Toggle' })
  vim.keymap.set('v', 'ga', ':CodeCompanionChat Add<CR>', { desc = 'Add to chat' })
end)
