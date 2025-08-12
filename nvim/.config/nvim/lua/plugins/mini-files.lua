MiniDeps.later(function()
  local function map_split(buf_id, lhs, direction)
    local minifiles = require('mini.files')

    local function rhs()
      local window = minifiles.get_explorer_state().target_window
      if window == nil or minifiles.get_fs_entry().fs_type == 'directory' then return end

      local new_target_window
      vim.api.nvim_win_call(window, function()
        vim.cmd(direction .. ' split')
        new_target_window = vim.api.nvim_get_current_win()
      end)

      minifiles.set_target_window(new_target_window)
      minifiles.go_in({ close_on_file = true })
    end

    vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = 'Split ' .. string.sub(direction, 12) })
  end

  vim.keymap.set('n', '-', function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local path = vim.fn.fnamemodify(bufname, ':p')
    if path and vim.uv.fs_stat(path) then require('mini.files').open(bufname, false) end
  end)

  require('mini.files').setup({
    mappings = {
      show_help = '?',
      go_in = '',
      go_out = '',
      go_in_plus = '<CR>',
      go_out_plus = '-',
    },
  })

  vim.api.nvim_create_autocmd('User', {
    desc = 'Notify LSPs that a file was renamed',
    group = vim.api.nvim_create_augroup('crnvl96-minifiles-lsp', {}),
    pattern = { 'MiniFilesActionRename', 'MiniFilesActionMove' },
    callback = function(args)
      local changes = {
        files = {
          {
            oldUri = vim.uri_from_fname(args.data.from),
            newUri = vim.uri_from_fname(args.data.to),
          },
        },
      }
      local will_rename_method, did_rename_method =
        vim.lsp.protocol.Methods.workspace_willRenameFiles, vim.lsp.protocol.Methods.workspace_didRenameFiles
      local clients = vim.lsp.get_clients()
      for _, client in ipairs(clients) do
        if client:supports_method(will_rename_method) then
          local res = client:request_sync(will_rename_method, changes, 1000, 0)
          if res and res.result then vim.lsp.util.apply_workspace_edit(res.result, client.offset_encoding) end
        end
      end

      for _, client in ipairs(clients) do
        if client:supports_method(did_rename_method) then client:notify(did_rename_method, changes) end
      end
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    group = vim.api.nvim_create_augroup('crnvl96-minifiles-maps', {}),
    callback = function(args)
      local buf_id = args.data.buf_id
      map_split(buf_id, '<C-w>s', 'belowright horizontal')
      map_split(buf_id, '<C-w>v', 'belowright vertical')
    end,
  })

  vim.api.nvim_set_hl(0, 'MiniFilesCursorLine', { bg = nil, fg = nil })
end)
