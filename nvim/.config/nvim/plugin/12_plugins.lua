local add = MiniDeps.add
local now = MiniDeps.now
local later = MiniDeps.later
local set = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local au = vim.api.nvim_create_augroup

now(function()
  add { name = 'mini.nvim' }
  add 'nvim-lua/plenary.nvim'
  add 'neovim/nvim-lspconfig'
  require('mini.icons').setup()
end)

now(function()
  add 'nvim-treesitter/nvim-treesitter'

  require('nvim-treesitter.configs').setup {
    ensure_installed = {
      'c',
      'lua',
      'vim',
      'vimdoc',
      'query',
      'markdown',
      'markdown_inline',
      'javascript',
      'typescript',
      'tsx',
      'ruby',
      'python',
    },
    sync_install = false,
    ignore_install = {},
    highlight = { enable = true },
    indent = {
      enable = true,
      disable = { 'yaml' },
    },
  }
end)

later(function()
  add 'tpope/vim-dadbod'
  add 'kristijanhusak/vim-dadbod-ui'
  add 'tpope/vim-fugitive'
  add 'tpope/vim-rhubarb'
  add 'tpope/vim-sleuth'
  add 'mbbill/undotree'
  add 'christoomey/vim-tmux-navigator'

  set('n', '<C-h>', '<Cmd>TmuxNavigateLeft<CR>')
  set('n', '<C-j>', '<Cmd>TmuxNavigateDown<CR>')
  set('n', '<C-k>', '<Cmd>TmuxNavigateUp<CR>')
  set('n', '<C-l>', '<Cmd>TmuxNavigateRight<CR>')
end)

later(function()
  add 'mfussenegger/nvim-dap'
  add 'suketa/nvim-dap-ruby'

  require('dap-ruby').setup()

  local widgets = require 'dap.ui.widgets'

  set('n', '<leader>db', require('dap').toggle_breakpoint)
  set('n', '<leader>dc', require('dap').continue)
  set('n', '<leader>dt', require('dap').terminate)
  set('n', '<Leader>dr', require('dap').repl.toggle)
  set({ 'n', 'v' }, '<Leader>dh', require('dap.ui.widgets').hover)

  set('n', '<Leader>df', function() widgets.sidebar(widgets.frames).open() end)

  set('n', '<Leader>ds', function() widgets.sidebar(widgets.scopes).open() end)
end)

later(function()
  add 'ibhagwan/fzf-lua'

  require('fzf-lua').setup {
    fzf_opts = {
      ['--cycle'] = '',
    },
    winopts = {
      preview = {
        vertical = 'down:45%',
        horizontal = 'right:60%',
        layout = 'flex',
        flip_columns = 150,
      },
    },
    keymap = {
      fzf = {
        ['ctrl-q'] = 'select-all+accept',
        ['ctrl-r'] = 'toggle+down',
        ['ctrl-e'] = 'toggle+up',
        ['ctrl-a'] = 'select-all',
        ['ctrl-o'] = 'toggle-all',
        ['ctrl-u'] = 'half-page-up',
        ['ctrl-d'] = 'half-page-down',
        ['ctrl-x'] = 'jump',
        ['ctrl-f'] = 'preview-page-down',
        ['ctrl-b'] = 'preview-page-up',
      },
      builtin = {
        ['<c-f>'] = 'preview-page-down',
        ['<c-b>'] = 'preview-page-up',
      },
    },
  }

  vim.ui.select = function(items, opts, on_choice)
    if not require('fzf-lua.providers.ui_select').is_registered() then
      require('fzf-lua.providers.ui_select').register()
    end

    if #items > 0 then return vim.ui.select(items, opts, on_choice) end
  end

  set('n', '<Leader>f', function() require('fzf-lua').files() end)

  set('n', '<Leader>l', function() require('fzf-lua').blines() end)

  set('n', '<Leader>g', function() require('fzf-lua').live_grep() end)

  set('x', '<Leader>g', function() require('fzf-lua').grep_visual() end)

  set('n', '<Leader>b', function() require('fzf-lua').buffers() end)

  set('n', '<Leader>\'', function() require('fzf-lua').resume() end)

  set('n', '<Leader>x', function() require('fzf-lua').quickfix() end)
end)

later(function()
  local minifiles = require 'mini.files'

  local function map_split(bufnr, lhs, direction)
    local function rhs()
      local window = minifiles.get_explorer_state().target_window
      if window == nil or minifiles.get_fs_entry().fs_type == 'directory' then
        return
      end

      local new_target_window
      vim.api.nvim_win_call(window, function()
        vim.cmd(direction .. ' split')
        new_target_window = vim.api.nvim_get_current_win()
      end)

      minifiles.set_target_window(new_target_window)
      minifiles.go_in { close_on_file = true }
    end

    vim.keymap.set(
      'n',
      lhs,
      rhs,
      { buffer = bufnr, desc = 'Split ' .. string.sub(direction, 12) }
    )
  end

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    group = vim.api.nvim_create_augroup('crnvl96-minifiles', {}),
    callback = function(args)
      local bufnr = args.data.buf_id
      map_split(bufnr, '<C-w>s', 'belowright horizontal')
      map_split(bufnr, '<C-w>v', 'belowright vertical')
    end,
  })

  vim.keymap.set('n', '-', function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local path = vim.fn.fnamemodify(bufname, ':p')
    if path and vim.uv.fs_stat(path) then minifiles.open(bufname, false) end
  end)

  minifiles.setup {
    mappings = {
      show_help = '?',
      go_in_plus = '<CR>',
      go_out_plus = '-',
      go_in = '',
      go_out = '',
    },
  }
end)

later(function()
  add 'olimorris/codecompanion.nvim'

  local adapter = 'venice'

  local function retrieve_llm_key(key_name)
    local filepath = '.env'
    local file = io.open(filepath, 'r')

    if not file then return nil end

    for line in file:lines() do
      -- Trim leading and trailing whitespace from the line
      line = line:match '^%s*(.-)%s*$'

      -- Skip empty lines and lines that are comments (starting with '#')
      if line ~= '' and not line:match '^#' then
        local eq_pos = line:find '='
        if eq_pos then
          local current_key = line:sub(1, eq_pos - 1)
          local current_value = line:sub(eq_pos + 1)

          -- Trim whitespace from the extracted key and value
          current_key = current_key:match '^%s*(.-)%s*$'
          current_value = current_value:match '^%s*(.-)%s*$'

          if current_key == key_name then
            file:close()
            return current_value
          end
        end
      end
    end

    file:close()
    return nil -- Key not found in the file
  end

  require('codecompanion').setup {
    strategies = {
      chat = {
        adapter = adapter,
        keymaps = {
          completion = {
            modes = {
              i = '<C-n>',
            },
          },
        },
        slash_commands = {
          file = {
            opts = {
              provider = 'fzf_lua',
            },
          },
          buffer = {
            opts = {
              provider = 'fzf_lua',
            },
          },
        },
      },
    },
    adapters = {
      gemini = function()
        return require('codecompanion.adapters').extend('gemini', {
          env = {
            api_key = retrieve_llm_key 'GEMINI_API_KEY',
          },
        })
      end,

      anthropic = function()
        return require('codecompanion.adapters').extend('anthropic', {
          env = {
            api_key = retrieve_llm_key 'ANTHROPIC_API_KEY',
          },
        })
      end,

      deepseek = function()
        return require('codecompanion.adapters').extend('deepseek', {
          env = {
            api_key = retrieve_llm_key 'DEEPSEEK_API_KEY',
          },
        })
      end,

      xai = function()
        return require('codecompanion.adapters').extend('xai', {
          env = {
            api_key = retrieve_llm_key 'XAI_API_KEY',
          },
        })
      end,

      openai = function()
        return require('codecompanion.adapters').extend('openai', {
          env = {
            api_key = retrieve_llm_key 'OPENAI_API_KEY',
          },
        })
      end,

      venice = function()
        return require('codecompanion.adapters').extend('openai_compatible', {
          name = 'venice',
          formatted_name = 'Venice',
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
          env = {
            url = 'https://api.venice.ai/api',
            chat_url = '/v1/chat/completions',
            api_key = retrieve_llm_key 'VENICE_API_KEY',
          },
          schema = {
            model = {
              default = 'deepseek-coder-v2-lite',
            },
            temperature = {
              order = 2,
              mapping = 'parameters',
              type = 'number',
              optional = true,
              default = 0.8,
              desc = 'What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.',
              validate = function(n)
                return n >= 0 and n <= 2, 'Must be between 0 and 2'
              end,
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
              desc = 'Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model\'s likelihood to talk about new topics.',
              validate = function(n)
                return n >= -2 and n <= 2, 'Must be between -2 and 2'
              end,
            },
            top_p = {
              order = 5,
              mapping = 'parameters',
              type = 'number',
              optional = true,
              default = 0.9,
              desc = 'A higher value (e.g., 0.95) will lead to more diverse text, while a lower value (e.g., 0.5) will generate more focused and conservative text. (Default: 0.9)',
              validate = function(n)
                return n >= 0 and n <= 1, 'Must be between 0 and 1'
              end,
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
              desc = 'Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model\'s likelihood to repeat the same line verbatim.',
              validate = function(n)
                return n >= -2 and n <= 2, 'Must be between -2 and 2'
              end,
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
                validate = function(n)
                  return n >= -100 and n <= 100, 'Must be between -100 and 100'
                end,
              },
            },
          },
        })
      end,
    },
  }

  vim.keymap.set({ 'n', 'v' }, '<Leader>ca', '<cmd>CodeCompanionActions<cr>')
  vim.keymap.set({ 'n', 'v' }, '<Leader>cc', '<cmd>CodeCompanionChat Toggle<cr>')
  vim.keymap.set('v', 'ga', '<cmd>CodeCompanionChat Add<cr>')
end)

later(function()
  add 'stevearc/conform.nvim'

  vim.o.formatexpr = 'v:lua.require\'conform\'.formatexpr()'
  vim.g.conform = true

  require('conform').setup {
    notify_on_error = true,
    formatters = {
      injected = {
        ignore_errors = true,
      },
    },
    formatters_by_ft = {
      ['_'] = { 'trim_whitespace', 'trim_newlines' },
      lua = { 'stylua' },
      json = { 'prettier' },
      markdown = { 'prettier', 'injected' },
      python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },

      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      css = { 'prettier' },
      javascript = { 'prettier' },

      ruby = { 'rubocop' },
      eruby = { 'rubocop' },
    },
    format_on_save = function()
      return vim.g.conform and { timeout_ms = 3000, lsp_format = 'fallback' }
    end,
  }
end)

later(function()
  add 'mfussenegger/nvim-lint'

  local lint = require 'lint'

  lint.linters_by_ft = {
    css = { 'stylelint' },
  }

  autocmd({ 'BufWritePost', 'InsertLeave', 'TextChanged' }, {
    group = au('crnvl96-try-lint', {}),
    callback = function() lint.try_lint() end,
  })
end)
