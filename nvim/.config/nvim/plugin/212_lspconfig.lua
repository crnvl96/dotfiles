Utils.SetNodePath(os.getenv('HOME') .. '/.asdf/installs/nodejs/20.17.0')
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

-- Utils.Group('crnvl96-markdown-lsp', function(g)
--   Utils.Autocmd('FileType', {
--     group = g,
--     pattern = 'markdown',
--     callback = function(args)
--       vim.lsp.start({
--         name = 'iwes',
--         cmd = { 'iwes' },
--         root_dir = vim.fs.root(args.buf, { '.iwe' }),
--         flags = {
--           debounce_text_changes = 500,
--         },
--       })
--     end,
--   })
-- end)
