if not vim.loop.fs_stat(MINI_PATH) then
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    MINI_PATH,
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({ path = { snapshot = NVIM_DIR .. '/mini-deps-snap' } })

MiniDeps.add({ name = 'mini.nvim' })
