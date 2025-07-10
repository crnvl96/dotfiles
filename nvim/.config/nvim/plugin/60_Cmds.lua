-- [Auto]Commands ================================================================

vim.api.nvim_create_user_command('Scratch', function()
  vim.cmd('bel 10new')
  local buf = vim.api.nvim_get_current_buf()
  for name, value in pairs({
    filetype = 'scratch',
    buftype = 'nofile',
    bufhidden = 'wipe',
    swapfile = false,
    modifiable = true,
  }) do
    vim.api.nvim_set_option_value(name, value, { buf = buf })
  end
end, { desc = 'Open a scratch buffer', nargs = 0 })

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('crnvl96-big-file', {}),
  pattern = 'bigfile', -- defined on filetype.lua
  callback = function(args)
    vim.schedule(function() vim.bo.syntax = vim.filetype.match({ buf = args.buf }) or '' end)
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('crnvl96-yank-hl', {}),
  callback = function()
    vim.hl.on_yank({
      priority = 250,
      higroup = 'IncSearch',
      timeout = 150,
    })
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('crnvl96-last-location', {}),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then vim.cmd('normal! g`"zz') end
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('crnvl96-on-lsp-attach', {}),
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if not client then return end

    local bufnr = e.buf

    local s = function(lhs, rhs, opts, mode)
      opts = vim.tbl_extend('error', opts or {}, { buffer = bufnr })
      mode = mode or 'n'
      return vim.keymap.set(mode, lhs, rhs, opts)
    end

    s('E', vim.diagnostic.open_float)
    s('K', vim.lsp.buf.hover)
    s('ga', vim.lsp.buf.code_action)
    s('gn', vim.lsp.buf.rename)
    s('gd', vim.lsp.buf.definition)
    s('gD', vim.lsp.buf.declaration)
    s('gr', vim.lsp.buf.references, { nowait = true })
    s('gi', vim.lsp.buf.implementation)
    s('gy', vim.lsp.buf.type_definition)
    s('ge', vim.diagnostic.setqflist)
    s('gs', vim.lsp.buf.document_symbol)
    s('gS', vim.lsp.buf.workspace_symbol)
    s('<C-k>', vim.lsp.buf.signature_help, {}, 'i')
  end,
})
