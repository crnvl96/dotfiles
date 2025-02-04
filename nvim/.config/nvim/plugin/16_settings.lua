_G.MiniOperators = function()
  return {
    evaluate = { prefix = 'g=' },
    replace = { prefix = 'gr' },
    exchange = { prefix = '' },
    multiply = { prefix = '' },
    sort = { prefix = '' },
  }
end

_G.MiniSnippets = function()
  return {
    snippets = {
      require('mini.snippets').gen_loader.from_file('~/.config/nvim/snippets/global.json'),
      require('mini.snippets').gen_loader.from_lang(),
    },
  }
end

_G.Treesitter = function()
  return {
    highlight = { enable = true },
    indent = { enable = true, disable = { 'yaml' } },
    sync_install = false,
    auto_install = true,
    ensure_installed = {
      'c',
      'vim',
      'vimdoc',
      'query',
      'markdown',
      'markdown_inline',
      'lua',
      'javascript',
      'typescript',
      'tsx',
      'python',
      'sql',
      'csv',
    },
  }
end

_G.SnacksSpec = function()
  return {
    bigfile = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    explorer = {
      replace_netrw = true,
    },
    gitbrowse = {
      notify = true,
      open = function(url) vim.fn.setreg('+', url) end,
    },
    picker = {
      formatters = {
        file = {
          filename_first = true,
        },
      },
      sources = {
        explorer = {},
      },
      win = {
        input = {
          keys = {
            ['yy'] = 'copy',
            ['<c-y>'] = { 'copy', mode = { 'n', 'i' } },
          },
        },
        list = { keys = { ['yy'] = 'copy' } },
      },
    },
  }
end

_G.Conform = function()
  return {
    notify_on_error = true,
    formatters = { injected = { ignore_errors = true } },
    formatters_by_ft = {
      ['_'] = { 'trim_whitespace', 'trim_newlines' },
      lua = { 'stylua' },
      javascript = { 'prettierd' },
      css = { 'prettierd' },
      html = { 'prettierd' },
      scss = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      typescript = { 'prettierd' },
      typescriptreact = { 'prettierd' },
      json = { 'prettierd' },
      jsonc = { 'prettierd' },
      yaml = { 'yamlfmt' },
      yml = { 'yamlfmt' },
      toml = { 'taplo' },
      markdown = { 'prettierd', 'injected' },
      python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
    },
    format_on_save = function()
      if not vim.g.autoformat then return end
      return {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = 'fallback',
      }
    end,
  }
end

_G.Codecompanion = function()
  return {
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
    display = {
      chat = {
        window = {
          layout = 'buffer',
        },
      },
    },
    adapters = {
      huggingface = require('codecompanion.adapters').extend('huggingface', {
        env = { api_key = Utils.ReadFromFile('huggingface') },
        schema = {
          model = {
            -- available models can be found at https://huggingface.co/models?inference=warm&pipeline_tag=text-generation
            -- https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/adapters/huggingface.lua
            default = 'deepseek-ai/DeepSeek-R1-Distill-Qwen-32B',
          },
        },
      }),
      anthropic = require('codecompanion.adapters').extend('anthropic', {
        env = { api_key = Utils.ReadFromFile('anthropic') },
        schema = {
          model = {
            -- https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/adapters/anthropic.lua
            default = 'claude-3-5-haiku-20241022',
          },
        },
      }),
      deepseek = require('codecompanion.adapters').extend('deepseek', {
        env = { api_key = Utils.ReadFromFile('deepseek') },
        schema = {
          model = {
            -- https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/adapters/deepseek.lua
            default = 'deepseek-chat',
          },
        },
      }),
    },
  }
end

_G.Blink = function()
  return {
    enabled = function()
      return not vim.tbl_contains({ 'minifiles' }, vim.bo.filetype)
        and vim.bo.buftype ~= 'prompt'
        and vim.b.completion ~= false
    end,
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = 'mono',
    },
    snippets = { preset = 'mini_snippets' },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    completion = {
      ghost_text = {
        enabled = false,
      },
      list = {
        selection = {
          preselect = function(ctx) return ctx.mode ~= 'cmdline' end,
          auto_insert = function(ctx) return ctx.mode == 'cmdline' end,
        },
      },
      menu = {
        border = 'rounded',
        scrollbar = false,
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        window = {
          border = 'rounded',
          scrollbar = false,
        },
      },
    },
    signature = {
      enabled = true,
      window = { border = 'rounded' },
    },
  }
end

_G.Servers = function()
  return {
    vtsls = {
      root_dir = function(_, buffer) return buffer and vim.fs.root(buffer, { 'package.json' }) end,
      single_file_support = false,
    },
    eslint = {
      workingDirectories = { mode = 'auto' },
    },
    ruff = {
      on_attach = function(client) client.server_capabilities.hoverProvider = false end,
      cmd_env = { RUFF_TRACE = 'messages' },
      init_options = {
        settings = {
          logLevel = 'debug',
        },
      },
    },
    basedpyright = {
      settings = {
        basedpyright = {
          disableOrganizeImports = true,
          analysis = {
            typeCheckingMode = 'strict',
            autoSearchPaths = false,
            diagnosticMode = 'openFilesOnly',
            useLibraryCodeForTypes = false,
          },
        },
      },
    },
    lua_ls = {
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then return end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          diagnostics = {
            globals = {
              'vim',
            },
          },
          runtime = {
            version = 'LuaJIT',
          },
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
              '${3rd}/luv/library',
            },
          },
        })
      end,
      settings = {
        Lua = {
          format = { enable = false },
          hint = {
            enable = true,
            arrayIndex = 'Disable',
          },
          completion = {
            callSnippet = 'Replace',
          },
        },
      },
    },
  }
end

_G.Which_Key = function()
  return {
    preset = 'helix',
    triggers = {
      { '<auto>', mode = 'nxso' },
    },
    icons = {
      mappings = false,
    },
    show_help = false,
    show_keys = false,
  }
end

_G.WK_Clues = function()
  return {
    {
      mode = { 'n' },
      { '<leader>d', group = 'Dap' },
      { '<leader>u', group = 'Toggle' },
    },
    {
      mode = { 'n', 'v' },
      { '<leader>d', group = 'Dap' },
    },
  }
end
