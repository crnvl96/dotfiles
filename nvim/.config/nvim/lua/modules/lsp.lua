local l = require('utils.lsp')

l.set_global_config()
l.enable_allowed_servers()

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('crnvl96-on-lsp-attach', { clear = true }),
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)

    if not client then return end

    local set = function(lhs, rhs, desc, mode)
      return vim.keymap.set(mode or 'n', lhs, rhs, { buffer = e.buf, desc = desc, nowait = true })
    end

    set('E', vim.diagnostic.open_float, 'Show Error')
    set('K', vim.lsp.buf.hover, 'Hover')
    set('ga', vim.lsp.buf.code_action, 'Code Actions')
    set('gn', vim.lsp.buf.rename, 'Rename Symbol')
    set('gd', vim.lsp.buf.definition, 'Goto Definition')
    set('gD', vim.lsp.buf.declaration, 'Goto Declaration')
    set('gr', vim.lsp.buf.references, 'Goto References')
    set('gi', vim.lsp.buf.implementation, 'Goto Implementations')
    set('gt', vim.lsp.buf.type_definition, 'Goto T[y]pe Definitions')
    set('ge', vim.diagnostic.setqflist, 'Send Diagnostics to Qf list')
    set('gs', vim.lsp.buf.document_symbol, 'Show Document Symbols')
    set('gS', vim.lsp.buf.workspace_symbol, 'Show Workspace Symbols')
    set('<C-k>', vim.lsp.buf.signature_help, 'Signature Help', 'i')
  end,
})
