---
--- Global Variables
---

_G.HOME = os.getenv('HOME')
_G.NVIM_DIR = HOME .. '/.config/nvim'
_G.MINI_PATH = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'

---
--- Package Manager
---

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
require('mini.icons').setup()

require('settings')
require('plugins')
