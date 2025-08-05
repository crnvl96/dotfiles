local lsp_dir = NVIM_DIR .. '/lsp'
local excluded_servers = {}
local lsp_servers = {}

for _, file in ipairs(vim.fn.glob(lsp_dir .. '/*.lua', true, true)) do
  local server_name = vim.fn.fnamemodify(file, ':t:r')
  if not vim.tbl_contains(excluded_servers, server_name) then
    table.insert(lsp_servers, server_name)
    local chunk = assert(loadfile(file))
    vim.lsp.config(server_name, chunk())
  end
end

vim.lsp.enable(lsp_servers)

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

    if client:supports_method(methods.textDocument_completion) then
      local str = 'abcdefghijklmnopqrstuvwxyz,.:\'"'
      local char_table = {}

      for i = 1, #str do
        char_table[i] = str:sub(i, i)
      end

      client.server_capabilities.completionProvider.triggerCharacters = char_table

      vim.lsp.completion.enable(true, client.id, e.buf, { autotrigger = true })
      vim.cmd('set completeopt+=noselect')

      local function keymap(lhs, rhs, opts, mode)
        opts = type(opts) == 'string' and { desc = opts }
          or vim.tbl_extend('error', opts --[[@as table]], { buffer = bufnr })
        mode = mode or 'n'
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      local function feedkeys(keys)
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes(keys, true, false, true),
          'n',
          true
        )
      end

      local function pumvisible() return tonumber(vim.fn.pumvisible()) ~= 0 end

      keymap('<C-n>', function()
        if pumvisible() then
          feedkeys('<C-n>')
        else
          if next(vim.lsp.get_clients({ bufnr = e.buf })) then
            vim.lsp.completion.get()
          else
            if vim.bo.omnifunc == '' then
              feedkeys('<C-x><C-n>')
            else
              feedkeys('<C-x><C-o>')
            end
          end
        end
      end, 'Trigger/select next completion', 'i')
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
