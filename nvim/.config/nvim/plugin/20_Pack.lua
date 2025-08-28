-- Pack ================================================================

if not vim.loop.fs_stat(MINI_PATH) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    MINI_PATH,
  })
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({ path = { snapshot = NVIM_DIR .. '/mini-deps-snap' } })

-- Mini ================================================================

MiniDeps.add({ name = 'mini.nvim' }) -- Make the package manager handle itself

local predicate = function(notif)
  if not (notif.data.source == 'lsp_progress' and notif.data.client_name == 'lua_ls') then return true end
  -- Filter out some LSP progress notifications from 'lua_ls'
  return notif.msg:find('Diagnosing') == nil and notif.msg:find('semantic tokens') == nil
end

local custom_sort = function(notif_arr) return require('mini.notify').default_sort(vim.tbl_filter(predicate, notif_arr)) end

require('mini.notify').setup({ content = { sort = custom_sort } })

vim.notify = require('mini.notify').make_notify()
