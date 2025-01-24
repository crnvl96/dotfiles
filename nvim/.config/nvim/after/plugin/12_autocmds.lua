Utils.Group('crnvl96-handle-linters', function(g)
  local linters = {
    lua = {
      linters = { 'selene' },
      cond = function(buf) return vim.fs.root(buf, { 'selene.toml' }) ~= nil end,
    },
  }

  Utils.Autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
    group = g,
    callback = function(e)
      local ft = vim.bo[e.buf].ft
      local linter = linters[ft]

      if (linter and not linter.cond) or (linter and linter.cond(e.buf)) then
        require('lint').try_lint(linter.linters)
      end
    end,
  })
end)

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
