local function on_attach(client, buf)
  client.server_capabilities.documentFormattingProvider = false
  vim.bo[buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
  vim.keymap.set('n', 'grr', vim.lsp.buf.references, { desc = 'vim.lsp.buf.references()', buffer = buf })
  vim.keymap.set('n', 'grd', vim.lsp.buf.definition, { desc = 'vim.lsp.buf.definition()', buffer = buf })
  vim.keymap.set('n', 'gri', vim.lsp.buf.implementation, { desc = 'vim.lsp.buf.implementation()', buffer = buf })
  vim.keymap.set('n', 'gry', vim.lsp.buf.type_definition, { desc = 'vim.lsp.buf.typedefs()', buffer = buf })
  vim.keymap.set('n', 'gra', vim.lsp.buf.code_action, { desc = 'vim.lsp.buf.code_action()', buffer = buf })
  vim.keymap.set('n', 'grs', vim.lsp.buf.document_symbol, { desc = 'vim.lsp.buf.document_symbol()', buffer = buf })
  vim.keymap.set('n', 'grx', vim.diagnostic.setqflist, { desc = 'vim.diagnistic.setqflist()', buffer = buf })
  vim.keymap.set('n', 'grS', vim.lsp.buf.workspace_symbol, { desc = 'vim.lsp.buf.workspace_symbol()', buffer = buf })
  vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { desc = 'vim.lsp.buf.signature_help()', buffer = buf })
end

vim.diagnostic.config({
  float = {
    focusable = false,
    style = 'minimal',
    border = 'none',
    source = true,
    header = '',
    prefix = '',
  },
})

local methods = vim.lsp.protocol.Methods
local register_capability = vim.lsp.handlers[methods.client_registerCapability]
vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then return end

  on_attach(client, vim.api.nvim_get_current_buf())

  return register_capability(err, res, ctx)
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if not client then return end
    on_attach(client, e.buf)
  end,
})
