require('mini.icons').setup()

require('mini.align').setup()
require('mini.operators').setup()
require('csvview').setup()

require('blink.compat').setup()
require('dap-view').setup()
require('nvim-dap-virtual-text').setup({ virt_text_pos = 'eol' })
require('dap-python').setup('uv')

require('snacks').setup({
  input = { enabled = true },
  notifier = { enabled = true },
  picker = {
    formatters = {
      file = {
        filename_first = true,
      },
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
})

require('nvim-treesitter.configs').setup({
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
})

require('blink.cmp').setup({
  enabled = function()
    return not vim.tbl_contains({ 'minifiles' }, vim.bo.filetype)
      and vim.bo.buftype ~= 'prompt'
      and vim.b.completion ~= false
  end,
  appearance = {
    use_nvim_cmp_as_default = false,
    nerd_font_variant = 'mono',
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
  sources = {
    transform_items = function(_, items)
      return vim.tbl_filter(
        function(item) return item.kind ~= require('blink.cmp.types').CompletionItemKind.Snippet end,
        items
      )
    end,
  },
  signature = {
    enabled = true,
    window = { border = 'rounded' },
  },
})

require('conform').setup({
  notify_on_error = true,
  formatters = { injected = { ignore_errors = true } },
  formatters_by_ft = {
    ['_'] = { 'trim_whitespace', 'trim_newlines' },
    lua = { 'stylua' },
    javascript = { 'prettierd' },
    css = { 'prettierd' },
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
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

local adapters = {
  'anthropic',
  'huggingface',
  'deepseek',
}

local adapter = adapters[1]

require('codecompanion').setup({
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
    },
    inline = { adapter = adapter },
    cmd = { adapter = adapter },
  },
  adapters = {
    huggingface = require('codecompanion.adapters').extend('huggingface', {
      env = { api_key = Utils.ReadFromFile('huggingface') },
      schema = {
        model = {
          -- available models can be found at https://huggingface.co/models?inference=warm&pipeline_tag=text-generation
          default = 'Qwen/Qwen2.5-Coder-32B-Instruct',
        },
      },
    }),
    deepseek = require('codecompanion.adapters').extend('deepseek', {
      env = { api_key = Utils.ReadFromFile('deepseek') },
    }),
    anthropic = require('codecompanion.adapters').extend('anthropic', {
      env = { api_key = Utils.ReadFromFile('anthropic') },
      schema = {
        model = {
          default = 'claude-3-5-haiku-20241022',
        },
      },
    }),
  },
})

require('dap.ext.vscode').json_decode = function(data)
  local decode = vim.json.decode
  local strip_comments = require('plenary.json').json_strip_comments
  data = strip_comments(data)
  return decode(data)
end

require('oil').setup({
  watch_for_changes = true,
  use_default_keymaps = false,
  keymaps = {
    ['g?'] = { 'actions.show_help', mode = 'n' },
    ['<CR>'] = 'actions.select',
    ['<C-w>v'] = { 'actions.select', opts = { vertical = true } },
    ['<C-w>h'] = { 'actions.select', opts = { horizontal = true } },
    ['<C-w>t'] = { 'actions.select', opts = { tab = true } },
    ['<C-w>p'] = 'actions.preview',
    ['<C-c>'] = { 'actions.close', mode = 'n' },
    ['<C-w>r'] = 'actions.refresh',
    ['<M-o>'] = { 'actions.parent', mode = 'n' },
    ['@'] = { 'actions.open_cwd', mode = 'n' },
    ['`'] = { 'actions.cd', mode = 'n' },
    ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
    ['gs'] = { 'actions.change_sort', mode = 'n' },
    ['gx'] = 'actions.open_external',
    ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
    ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
  },
})

local miniclue = require('mini.clue')

miniclue.setup({

  triggers = {
    -- Leader
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },

    -- Builtin completion
    { mode = 'i', keys = '<C-x>' },

    -- `g` key
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },

    -- Marks
    { mode = 'n', keys = "'" },
    { mode = 'x', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = '`' },

    -- Registers
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },

    -- Windows
    { mode = 'n', keys = '<C-w>' },

    -- `z` key
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },
  },
  clues = {
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),

    -- Buffers
    { mode = 'n', keys = '<Leader>b', desc = 'Buffers' },

    -- Ai assistant
    { mode = 'n', keys = '<Leader>c', desc = 'Code (AI)' },
    { mode = 'x', keys = '<Leader>c', desc = 'Code (AI)' },

    -- Debug
    { mode = 'n', keys = '<Leader>d', desc = 'Dap' },
    { mode = 'x', keys = '<Leader>d', desc = 'Dap' },

    -- Find
    { mode = 'n', keys = '<Leader>f', desc = 'Find' },

    -- Git
    { mode = 'n', keys = '<Leader>g', desc = 'Git' },
    { mode = 'x', keys = '<Leader>g', desc = 'Git' },
    { mode = 'n', keys = '<Leader>gl', desc = 'Log' },

    -- LSP
    { mode = 'n', keys = '<Leader>l', desc = 'LSP' },

    -- Notifications
    { mode = 'n', keys = '<Leader>n', desc = 'Notifications' },

    -- Toggling features
    { mode = 'n', keys = '<Leader>u', desc = 'Toggle' },
  },
  window = {
    config = {
      width = 'auto',
    },
    delay = 200,
    scroll_down = '<C-f>',
    scroll_up = '<C-b>',
  },
})

for server, config in pairs({
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
          autoSearchPaths = true,
          diagnosticMode = 'openFilesOnly',
          useLibraryCodeForTypes = true,
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
          callSnippet = 'Disable',
          keywordSnippet = 'Disable',
        },
      },
    },
  },
}) do
  config = config or {}
  config.capabilities = require('blink.cmp').get_lsp_capabilities({
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = false,
        },
      },
    },
  })
  require('lspconfig')[server].setup(config)
end

vim.print = function(...) require('snacks').debug.inspect(...) end
