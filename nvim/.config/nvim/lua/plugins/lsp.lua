MiniDeps.add('williamboman/mason-lspconfig.nvim')
MiniDeps.add('neovim/nvim-lspconfig')
MiniDeps.add({
  source = 'williamboman/mason.nvim',
  hooks = {
    post_checkout = function() vim.cmd('MasonUpdate') end,
  },
})
MiniDeps.add('WhoIsSethDaniel/mason-tool-installer.nvim')

local capabilities = function() return vim.tbl_deep_extend('force', {}, vim.lsp.protocol.make_client_capabilities()) end

local servers = {
  vtsls = {},
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
            '${3rd}/luv/library',
            '${3rd}/busted/library',
          },
        },
      },
    },
  },
  eslint = {
    settings = {
      format = false,
    },
  },
  gopls = {
    settings = {
      gopls = {
        gofumpt = true,
        buildFlags = { '-tags=debug' },
        experimentalPostfixCompletions = true,
        usePlaceholders = false,
        staticcheck = true,
        completeUnimported = true,
      },
    },
  },
}

require('mason').setup()

require('mason-tool-installer').setup({
  ensure_installed = vim.list_extend(vim.tbl_keys(servers or {}), {
    'stylua',
    'prettierd',
    'staticcheck',
    'gofumpt',
    'goimports',
    'golines',
  }),
})

local on_attach = function(client, buf)
  client.server_capabilities.documentFormattingProvider = false

  -- vim.bo[buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
  vim.bo[buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'

  vim.keymap.set('n', 'grr', vim.lsp.buf.references, { desc = 'vim.lsp.buf.references()', buffer = buf })
  vim.keymap.set('n', 'grd', vim.lsp.buf.definition, { desc = 'vim.lsp.buf.definition()', buffer = buf })
  vim.keymap.set('n', 'gri', vim.lsp.buf.implementation, { desc = 'vim.lsp.buf.implementation()', buffer = buf })
  vim.keymap.set('n', 'gry', vim.lsp.buf.type_definition, { desc = 'vim.lsp.buf.typedefs()', buffer = buf })
  vim.keymap.set('n', 'gra', vim.lsp.buf.code_action, { desc = 'vim.lsp.buf.code_action()', buffer = buf })
  vim.keymap.set('n', 'grs', vim.lsp.buf.document_symbol, { desc = 'vim.lsp.buf.document_symbol()', buffer = buf })
  vim.keymap.set('n', 'grx', vim.diagnostic.setqflist, { desc = 'vim.diagnistic.setqflist()', buffer = buf })
  vim.keymap.set('n', 'grS', vim.lsp.buf.workspace_symbol, { desc = 'vim.lsp.buf.workspace_symbol()', buffer = buf })
  vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { desc = 'vim.lsp.buf.signature_help()', buffer = buf })

  vim.keymap.set('n', '<leader>rr', vim.lsp.buf.references, { desc = 'vim.lsp.buf.references()', buffer = buf })
  vim.keymap.set('n', '<leader>rd', vim.lsp.buf.definition, { desc = 'vim.lsp.buf.definition()', buffer = buf })
  vim.keymap.set('n', '<leader>ri', vim.lsp.buf.implementation, { desc = 'vim.lsp.buf.implementation()', buffer = buf })
  vim.keymap.set('n', '<leader>ry', vim.lsp.buf.type_definition, { desc = 'vim.lsp.buf.typedefs()', buffer = buf })
  vim.keymap.set('n', '<leader>ra', vim.lsp.buf.code_action, { desc = 'vim.lsp.buf.code_action()', buffer = buf })
  vim.keymap.set(
    'n',
    '<leader>rs',
    vim.lsp.buf.document_symbol,
    { desc = 'vim.lsp.buf.document_symbol()', buffer = buf }
  )
  vim.keymap.set('n', '<leader>rx', vim.diagnostic.setqflist, { desc = 'vim.diagnistic.setqflist()', buffer = buf })
  vim.keymap.set(
    'n',
    '<leader>rS',
    vim.lsp.buf.workspace_symbol,
    { desc = 'vim.lsp.buf.workspace_symbol()', buffer = buf }
  )
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if not client then return end
    on_attach(client, e.buf)
  end,
})

local mlsp = require('mason-lspconfig')
local lsp = require('lspconfig')

mlsp.setup({
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}

      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities(), server.capabilities or {})

      lsp[server_name].setup(server)
    end,
  },
})
