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

local node_version_cmd = "mise ls --cd ~ | grep '^node' | grep '22\\.' | head -n 1 | awk '{print $2}'"
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
require('plugins.conform')
require('plugins.blink')

---
--- Fzf-lua.nvim - general fuzzy finder
---

MiniDeps.later(function()
  MiniDeps.add('ibhagwan/fzf-lua')

  local actions = require('fzf-lua').actions
  require('fzf-lua').setup({
    'hide',
    fzf_opts = {
      ['--cycle'] = '',
    },
    files = {
      prompt = '🪿 ',
    },
    actions = {
      files = {
        true,
        ['enter'] = actions.file_edit_or_qf,
        ['ctrl-s'] = actions.file_split,
        ['ctrl-v'] = actions.file_vsplit,
        ['ctrl-t'] = actions.file_tabedit,
        ['alt-x'] = actions.file_sel_to_qf,
        ['alt-X'] = actions.file_sel_to_ll,
        ['alt-i'] = actions.toggle_ignore,
        ['alt-h'] = actions.toggle_hidden,
        ['alt-f'] = actions.toggle_follow,
      },
    },
    winopts = {
      preview = {
        vertical = 'down:45%',
        horizontal = 'right:60%',
        layout = 'flex',
        flip_columns = 150,
      },
    },
    keymap = {
      fzf = {
        ['ctrl-q'] = 'select-all+accept',
        ['ctrl-r'] = 'toggle+down',
        ['ctrl-e'] = 'toggle+up',
        ['ctrl-a'] = 'select-all',
        ['ctrl-o'] = 'toggle-all',
        ['ctrl-u'] = 'half-page-up',
        ['ctrl-d'] = 'half-page-down',
        ['ctrl-x'] = 'jump',
        ['ctrl-f'] = 'preview-page-down',
        ['ctrl-b'] = 'preview-page-up',
      },
      builtin = {
        ['<c-f>'] = 'preview-page-down',
        ['<c-b>'] = 'preview-page-up',
      },
    },
  })

  require('fzf-lua').register_ui_select()

  vim.keymap.set('n', '<Leader>f', function() require('fzf-lua').files() end, { desc = 'Files' })
  vim.keymap.set('n', '<Leader>l', function() require('fzf-lua').blines() end, { desc = 'Lines' })
  vim.keymap.set('n', '<Leader>g', function() require('fzf-lua').live_grep() end, { desc = 'Grep' })
  vim.keymap.set('x', '<Leader>g', function() require('fzf-lua').grep_visual() end, { desc = 'Grep' })
  vim.keymap.set('n', '<Leader>b', function() require('fzf-lua').buffers() end, { desc = 'Buffers' })
  vim.keymap.set('n', "<Leader>'", function() require('fzf-lua').resume() end, { desc = 'Resume' })
  vim.keymap.set('n', '<Leader>x', function() require('fzf-lua').quickfix() end, { desc = 'Quickfix' })
end)

---
--- Mini.files - nvim file manager
---

MiniDeps.later(function()
  local minifiles = require('mini.files')

  local function map_split(bufnr, lhs, direction)
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

    vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = 'Split ' .. string.sub(direction, 12) })
  end

  minifiles.setup({
    mappings = {
      show_help = '?',
      go_in_plus = '<CR>',
      go_out_plus = '-',
      go_in = '',
      go_out = '',
    },
  })

  vim.keymap.set('n', '-', function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local path = vim.fn.fnamemodify(bufname, ':p')
    if path and vim.uv.fs_stat(path) then minifiles.open(bufname, false) end
  end)

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    group = vim.api.nvim_create_augroup('crnvl96-minifiles', {}),
    callback = function(e)
      local bufnr = e.data.buf_id
      map_split(bufnr, '<C-w>s', 'belowright horizontal')
      map_split(bufnr, '<C-w>v', 'belowright vertical')
    end,
  })
end)
