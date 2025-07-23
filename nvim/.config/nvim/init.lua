---
--- Global Variables
---

_G.HOME = os.getenv('HOME')
_G.NVIM_DIR = HOME .. '/.config/nvim'
_G.MINI_PATH = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'

---
--- Diagnostics
---

vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = false,
  float = { source = true },
  signs = false,
})

---
--- Filetypes
---

vim.filetype.add({
  filename = {
    ['.eslintrc.json'] = 'jsonc',
  },
  pattern = {
    ['tsconfig*.json'] = 'jsonc',
    ['.*/%.vscode/.*%.json'] = 'jsonc',
    ['.*'] = function(path, bufnr)
      return vim.bo[bufnr]
          and vim.bo[bufnr].filetype ~= 'bigfile'
          and path
          and vim.fn.getfsize(path) > (1024 * 500) -- 500kb
          and 'bigfile'
        or nil
    end,
  },
})

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

---
--- Colorscheme
---

vim.cmd.colorscheme('ansi')

---
--- NodeJS path
---

local node_version_cmd = "mise ls --cd ~ | grep '^node' | head -n 1 | awk '{print $2}'"
local node_version = vim.fn.system(node_version_cmd):gsub('\n', '')

if node_version == '' then
  vim.notify(
    'Could not determine Node.js version from mise. Please ensure mise is installed and a Node.js version is set.',
    vim.log.levels.WARN
  )
else
  local default_nodejs = HOME .. '/.local/share/mise/installs/node/' .. node_version .. '/bin/'
  vim.g.node_host_prog = default_nodejs .. 'node'
  vim.env.PATH = default_nodejs .. ':' .. vim.env.PATH
end

---
--- Load LSP servers
---

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

---
--- Settings
---

require('settings.opts')
require('settings.keymaps')
require('settings.autocmds')

---
--- Plugins
---

require('plugins')
require('plugins.mason')
require('plugins.treesitter')
require('plugins.grug-far')
require('plugins.conform')
require('plugins.nvim-lint')
require('plugins.nvim-dap')
require('plugins.blink')
require('plugins.codecompanion')
require('plugins.fzf')
require('plugins.minifiles')
require('plugins.rustaceanvim')
require('plugins.miniclue')
