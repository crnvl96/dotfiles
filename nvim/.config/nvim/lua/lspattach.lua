local buf = vim.lsp.buf
local au = vim.api.nvim_create_autocmd

-- stylua: ignore
local function on_attach(client, bufnr)
  local function set(lhs, rhs, desc)
    local s = vim.keymap.set
    s('n', lhs, rhs, { desc = desc, buffer = bufnr })
  end

  client.server_capabilities.documentFormattingProvider = false
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  set('grr',   buf.references,           'vim.lsp.buf.references()')
  set('grd',   buf.definition,           'vim.lsp.buf.definition()')
  set('gri',   buf.implementation,       'vim.lsp.buf.implementation()')
  set('gry',   buf.type_definition,      'vim.lsp.buf.typedefs()')
  set('gra',   buf.code_action,          'vim.lsp.buf.code_action()')
  set('grs',   buf.document_symbol,      'vim.lsp.buf.document_symbol()')
  set('grx',   vim.diagnostic.setqflist, 'vim.diagnistic.setqflist()')
  set('grS',   buf.workspace_symbol,     'vim.lsp.buf.workspace_symbol()')
  set('<C-k>', buf.signature_help,       'vim.lsp.buf.signature_help()')
end

au('LspAttach', {
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if not client then return end
    on_attach(client, e.buf)
  end,
})
