Utils.SetNodePath(os.getenv('HOME') .. '/.asdf/installs/nodejs/20.17.0')

local cargo = function(params)
  Later(function() Utils.Build(params, { 'cargo', 'build', '--release' }) end)
end

local K = Utils.Keymap
local H = {}

H.plenary = function() Add('nvim-lua/plenary.nvim') end

H.mini = function()
  require('mini.align').setup()
  require('mini.ai').setup()
  require('mini.operators').setup()
  require('mini.splitjoin').setup()
  require('mini.pick').setup()
  require('mini.diff').setup({ view = { style = 'sign' } })
end

H.fugitive = function()
  Add('tpope/vim-fugitive')
  K('Open', { lhs = '<Leader>gg', mode = 'n', rhs = '<Cmd>Git<CR>' })
  K('Diff', { lhs = '<Leader>gd', mode = 'n', rhs = '<Cmd>Gvdiffsplit!<CR>' })
  K('Commit', { lhs = '<Leader>gc', mode = 'n', rhs = '<Cmd>Git commit<CR>' })
  K('Amend', { lhs = '<Leader>gC', mode = 'n', rhs = '<Cmd>Git commit --amend<CR>' })
  K('Push', { lhs = '<Leader>gp', mode = 'n', rhs = '<Cmd>Git push<CR>' })
  K('Force push', { lhs = '<Leader>gP', mode = 'n', rhs = '<Cmd>Git push --force-with-lease<CR>' })
end

H.treesitter = function()
  Add({ source = 'nvim-treesitter/nvim-treesitter', hooks = { post_checkout = function() vim.cmd('TSUpdate') end } })

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
end

H.render_markdown = function()
  Add('MeanderingProgrammer/render-markdown.nvim')
  require('render-markdown').setup()
end

H.fidget = function()
  Add('j-hui/fidget.nvim')

  require('fidget').setup({
    notification = {
      window = {
        winblend = 0,
        border = 'rounded',
      },
    },
  })
end

H.csv_view = function()
  Add('hat0uma/csvview.nvim')
  require('csvview').setup()
end

H.snacks = function()
  Add('folke/snacks.nvim')

  require('snacks').setup({
    bigfile = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    explorer = {
      replace_netrw = true,
    },
    gitbrowse = {
      notify = false,
      open = function(url) vim.fn.setreg('+', url) end,
    },
    picker = {
      icons = {
        files = {
          enabled = false,
        },
      },
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
  })

  vim.print = function(...) require('snacks').debug.inspect(...) end

  local T = Snacks.toggle
  vim.g.autoformat = true

  local function set_autoformat(e)
    if e then
      vim.g.autoformat = true
    else
      vim.g.autoformat = false
    end
  end

  local wrap = T.option('wrap')
  local relnum = T.option('relativenumber')
  local autofmt = T({ name = 'Auto format', get = function() return vim.g.autoformat end, set = set_autoformat })

  wrap:map('<leader>uw', { desc = 'Wrap' })
  relnum:map('<leader>ur', { desc = 'Relnum' })
  autofmt:map('<Leader>ua', { desc = 'Autoformat' })

  K('Last', { lhs = '<Leader>bl', mode = 'n', rhs = '<Cmd>b#<CR>' })
  K('Delete', { lhs = '<Leader>bd', mode = 'n', rhs = function() Snacks.bufdelete.bufdelete() end })
  K('Others', { lhs = '<Leader>bo', mode = 'n', rhs = function() Snacks.bufdelete.other() end })

  K('Explorer', { lhs = '<Leader>e', mode = 'n', rhs = function() Snacks.picker.explorer() end })

  K('Buffers', { lhs = '<Leader>fb', mode = 'n', rhs = function() Snacks.picker.buffers() end })
  K('Files', { lhs = '<Leader>ff', mode = 'n', rhs = function() Snacks.picker.files({ hidden = true }) end })
  K('Grep', { lhs = '<Leader>fg', mode = 'n', rhs = function() Snacks.picker.grep({ hidden = true }) end })
  K('Grep', { lhs = '<Leader>sg', mode = { 'n', 'x' }, rhs = function() Snacks.picker.grep_word() end })
  K('Help', { lhs = '<Leader>fh', mode = 'n', rhs = function() Snacks.picker.help() end })
  K('Lines', { lhs = '<Leader>fl', mode = 'n', rhs = function() Snacks.picker.lines() end })
  K('Oldfiles', { lhs = '<Leader>fo', mode = 'n', rhs = function() Snacks.picker.recent() end })
  K('Resume', { lhs = '<Leader>fr', mode = 'n', rhs = function() Snacks.picker.resume() end })
  K('Pickers', { lhs = '<Leader>fp', mode = 'n', rhs = function() Snacks.picker.pickers() end })

  K('Blame', { lhs = '<Leader>gb', mode = 'n', rhs = function() Snacks.git.blame_line() end })
  K('Browse', { lhs = '<Leader>gB', mode = { 'n', 'v' }, rhs = function() Snacks.gitbrowse() end })

  local lsp_opts = {
    include_current = true,
    auto_confirm = false,
    jump = { reuse_win = false },
  }

  K('Actions', { lhs = '<Leader>la', mode = 'n', rhs = function() vim.lsp.buf.code_action() end })
  K('Eval', { lhs = 'K', mode = 'n', rhs = function() vim.lsp.buf.hover({ border = 'rounded' }) end })
  K('Help', { lhs = '<Leader>lh', mode = 'n', rhs = function() vim.lsp.buf.signature_help({ border = 'rounded' }) end })
  K('Eval Error', { lhs = 'E', mode = 'n', rhs = function() vim.diagnostic.open_float({ border = 'rounded' }) end })
  K('Rename', { lhs = '<Leader>lR', mode = 'n', rhs = function() vim.lsp.buf.rename() end })
  K('Definition', { lhs = '<Leader>ld', mode = 'n', rhs = function() Snacks.picker.lsp_definitions(lsp_opts) end })
  K('Impl', { lhs = '<Leader>li', mode = 'n', rhs = function() Snacks.picker.lsp_implementations(lsp_opts) end })
  K('References', { lhs = '<Leader>lr', mode = 'n', rhs = function() Snacks.picker.lsp_references(lsp_opts) end })
  K('Symbols', { lhs = '<Leader>ls', mode = 'n', rhs = function() Snacks.picker.lsp_symbols() end })
  K('Symbols (Project)', { lhs = '<Leader>lS', mode = 'n', rhs = function() Snacks.picker.lsp_workspace_symbols() end })
  K('Diagnostics', { lhs = '<Leader>lD', mode = 'n', rhs = function() Snacks.picker.diagnostics() end })
  K('Typedefs', { lhs = '<Leader>lt', mode = 'n', rhs = function() Snacks.picker.lsp_type_definitions(lsp_opts) end })

  K('History', { lhs = '<Leader>nh', mode = 'n', rhs = function() Snacks.notifier.show_history() end })
  K('Clear', { lhs = '<Leader>nc', mode = 'n', rhs = function() Snacks.notifier.hide() end })
end

H.conform = function()
  Add('stevearc/conform.nvim')

  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

  require('conform').setup({
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
  })
end

H.codecompanion = function()
  Add('olimorris/codecompanion.nvim')

  -- https://github.com/olimorris/codecompanion.nvim/tree/main/lua/codecompanion/adapters
  vim.g.codecompanion_adapter = 'huggingface'

  local progress = require('fidget.progress')

  local M = {}

  function M:init()
    local group = vim.api.nvim_create_augroup('CodeCompanionFidgetHooks', {})

    vim.api.nvim_create_autocmd({ 'User' }, {
      pattern = 'CodeCompanionRequestStarted',
      group = group,
      callback = function(request)
        local handle = M:create_progress_handle(request)
        M:store_progress_handle(request.data.id, handle)
      end,
    })

    vim.api.nvim_create_autocmd({ 'User' }, {
      pattern = 'CodeCompanionRequestFinished',
      group = group,
      callback = function(request)
        local handle = M:pop_progress_handle(request.data.id)
        if handle then
          M:report_exit_status(handle, request)
          handle:finish()
        end
      end,
    })
  end

  M.handles = {}

  function M:store_progress_handle(id, handle) M.handles[id] = handle end

  function M:pop_progress_handle(id)
    local handle = M.handles[id]
    M.handles[id] = nil
    return handle
  end

  function M:create_progress_handle(request)
    return progress.handle.create({
      title = ' Requesting assistance (' .. request.data.strategy .. ')',
      message = 'In progress...',
      lsp_client = {
        name = M:llm_role_title(request.data.adapter),
      },
    })
  end

  function M:llm_role_title(adapter)
    local parts = {}
    table.insert(parts, adapter.formatted_name)
    if adapter.model and adapter.model ~= '' then table.insert(parts, '(' .. adapter.model .. ')') end
    return table.concat(parts, ' ')
  end

  function M:report_exit_status(handle, request)
    if request.data.status == 'success' then
      handle.message = 'Completed'
    elseif request.data.status == 'error' then
      handle.message = ' Error'
    else
      handle.message = '󰜺 Cancelled'
    end
  end

  M:init()

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
  })

  K('Actions', { lhs = '<Leader>ca', mode = { 'n', 'v' }, rhs = '<Cmd>CodeCompanionActions<CR>' })
  K('Toggle', { lhs = '<Leader>ct', mode = { 'n', 'v' }, rhs = '<Cmd>CodeCompanionChat Toggle<CR>' })
  K('Chat', { lhs = '<Leader>cc', mode = 'v', rhs = ':CodeCompanionChat Add<CR>' })
end

H.dap = function()
  Add('theHamsta/nvim-dap-virtual-text')
  Add('mfussenegger/nvim-dap-python')
  Add('mfussenegger/nvim-dap')
  Add('igorlfs/nvim-dap-view')

  require('dap-view').setup()
  require('nvim-dap-virtual-text').setup({ virt_text_pos = 'eol' })
  require('dap-python').setup('uv')
  require('mini.snippets').setup({ snippets = { require('mini.snippets').gen_loader.from_lang() } })

  require('dap.ext.vscode').json_decode = function(data)
    local decode = vim.json.decode
    local strip_comments = require('plenary.json').json_strip_comments
    data = strip_comments(data)
    return decode(data)
  end

  local function dap_open_scopes()
    local widgets = require('dap.ui.widgets')
    widgets.sidebar(widgets.scopes, {}, 'vsplit').toggle()
  end

  K('REPL', { lhs = '<Leader>dR', mode = 'n', rhs = function() require('dap.repl').toggle({}, 'belowright split') end })
  K('Breakpoint', { lhs = '<Leader>db', mode = 'n', rhs = function() require('dap').toggle_breakpoint() end })
  K('Clear breakpoints', { lhs = '<Leader>dc', mode = 'n', rhs = function() require('dap').clear_breakpoints() end })
  K('Eval', { lhs = '<Leader>de', mode = { 'n', 'x' }, rhs = function() require('dap.ui.widgets').hover() end })
  K('Run', { lhs = '<Leader>dr', mode = 'n', rhs = function() require('dap').continue() end })
  K('Quit', { lhs = '<Leader>dq', mode = 'n', rhs = function() require('dap').terminate() end })
  K('Scopes', { lhs = '<Leader>ds', mode = 'n', rhs = dap_open_scopes })
end

H.blink_cmp = function()
  Add('saghen/blink.compat')

  require('blink.compat').setup()

  Add({ source = 'Saghen/blink.cmp', hooks = { post_install = cargo, post_checkout = cargo } })

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
  })
end

H.lspconfig = function()
  Add('neovim/nvim-lspconfig')

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
  }) do
    config = config or {}
    config.capabilities = require('blink.cmp').get_lsp_capabilities()
    require('lspconfig')[server].setup(config)
  end

  Utils.Group('crnvl96-lsp-on-attach', function(g)
    Utils.Autocmd('LspAttach', {
      group = g,
      callback = function(e)
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        if not client then return end

        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    })
  end)

  Utils.Group('crnvl96-markdown-notes-lsp', function(g)
    Utils.Autocmd('FileType', {
      group = g,
      pattern = 'markdown',
      callback = function(args)
        vim.lsp.start({
          name = 'iwes',
          cmd = { 'iwes' },
          root_dir = vim.fs.root(args.buf, { '.iwe' }),
          flags = {
            debounce_text_changes = 500,
          },
        })
      end,
    })
  end)
end

H.which_key = function()
  Add('folke/which-key.nvim')

  require('which-key').setup({
    preset = 'helix',
    triggers = {
      { '<auto>', mode = 'nxso' },
    },
    icons = {
      mappings = false,
    },
    show_help = false,
    show_keys = false,
  })

  require('which-key').add({
    {
      mode = { 'n' },
      { '<leader>b', group = 'Buffer' },
      { '<leader>c', group = 'Code' },
      { '<leader>d', group = 'Dap' },
      { '<leader>f', group = 'Find' },
      { '<leader>g', group = 'Git' },
      { '<leader>l', group = 'LSP' },
      { '<leader>n', group = 'Notification' },
      { '<leader>s', group = 'Search' },
      { '<leader>u', group = 'Toggle' },
    },
    {
      mode = { 'n', 'v' },
      { '<leader>c', group = 'Code' },
      { '<leader>d', group = 'Dap' },
      { '<leader>g', group = 'Git' },
      { '<leader>s', group = 'Search' },
    },
  })
end

H.plenary()
H.mini()
H.fugitive()
H.treesitter()
H.render_markdown()
H.fidget()
H.csv_view()
H.snacks()
H.conform()
H.codecompanion()
H.dap()
H.blink_cmp()
H.lspconfig()
H.which_key()
