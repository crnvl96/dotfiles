Add('neovim/nvim-lspconfig')

local capabilities = require('blink.cmp').get_lsp_capabilities()
for server, config in pairs({
  vtsls = {
    root_dir = function(_, buffer) return buffer and vim.fs.root(buffer, { 'package.json' }) end,
    single_file_support = false,
  },
  eslint = {
    root_dir = function(_, buffer) return buffer and vim.fs.root(buffer, { '.eslintrc.js' }) end,
    workingDirectories = { mode = 'auto' },
  },
  biome = {
    root_dir = function(_, buffer) return buffer and vim.fs.root(buffer, { 'biome.json', 'biome.jsonc' }) end,
  },
  ruff = {
    on_attach = function(client) client.server_capabilities.hoverProvider = false end,
    cmd_env = { RUFF_TRACE = 'messages' },
    init_options = {
      settings = {
        logLevel = 'debug',
        lineLength = 120,
        lint = {
          select = { 'ALL' },
          -- extendSelect = {},
          -- ignore = {},
        },
      },
    },
  },
  basedpyright = {
    settings = {
      basedpyright = {
        analysis = { typeCheckingMode = 'all' },
        disableOrganizeImports = true,
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
  config.capabilities = capabilities
  require('lspconfig')[server].setup(config)
end
