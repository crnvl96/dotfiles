vim.lsp.enable(vim
  .iter(vim.api.nvim_get_runtime_file('lsp/*.lua', true))
  :map(function(file)
    local server_name = vim.fn.fnamemodify(file, ':t:r')
    if not vim.tbl_contains({}, server_name) then return server_name end
  end)
  :totable())

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('crnvl96-on-lsp-attach', {}),
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if not client then return end

    local bufnr = e.buf

    local set = function(lhs, rhs, opts, mode)
      opts = vim.tbl_extend('error', opts or {}, { buffer = bufnr })
      mode = mode or 'n'
      return vim.keymap.set(mode, lhs, rhs, opts)
    end

    set('E', vim.diagnostic.open_float)
    set('K', vim.lsp.buf.hover)
    set('ga', vim.lsp.buf.code_action)
    set('gn', vim.lsp.buf.rename)
    set('gd', vim.lsp.buf.definition)
    set('gD', vim.lsp.buf.declaration)
    set('gr', vim.lsp.buf.references, { nowait = true })
    set('gi', vim.lsp.buf.implementation)
    set('gy', vim.lsp.buf.type_definition)
    set('ge', vim.diagnostic.setqflist)
    set('gs', vim.lsp.buf.document_symbol)
    set('gS', vim.lsp.buf.workspace_symbol)
    set('<C-k>', vim.lsp.buf.signature_help, {}, 'i')
  end,
})
