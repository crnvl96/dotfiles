local excluded_servers = {}

local server_configs = vim
  .iter(vim.api.nvim_get_runtime_file('lsp/*.lua', true))
  :map(function(file)
    local server_name = vim.fn.fnamemodify(file, ':t:r')
    if not vim.tbl_contains(excluded_servers, server_name) then return server_name end
  end)
  :totable()

vim.lsp.enable(server_configs)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('crnvl96-on-lsp-attach', {}),
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if not client then return end

    local methods = vim.lsp.protocol.Methods

    local bufnr = e.buf
    local win = vim.api.nvim_get_current_win()
    local filetype = e.match
    local lang = vim.treesitter.language.get_lang(filetype) or ''

    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

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

    if client:supports_method(methods.textDocument_formatting) then
      client.server_capabilities.documentFormattingProvider = true
    end

    if client:supports_method(methods.textDocument_foldingRange) then
      vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    else
      if vim.treesitter.language.add(lang) then
        vim.wo[win][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      end
    end
  end,
})
