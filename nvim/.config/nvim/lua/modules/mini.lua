local bind = require('utils.bind')
local builtin = require('utils.builtin')
local minipath = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'

---@class Nvim.Modules.Mini
local M = {
  clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    minipath,
  },
  ---@class Nvim.Modules.Mini.Theme
  theme = {
    palette = {
      background = vim.o.background == 'dark' and '#212223' or '#e1e2e3',
      foreground = vim.o.background == 'dark' and '#d5d4d3' or '#2f2e2d',
      saturation = vim.o.background == 'dark' and 'lowmedium' or 'mediumhigh',
      accent = 'bg',
    },
    transparency = {
      float = true,
      statuscolumn = true,
      statusline = true,
      tabline = true,
      winbar = true,
    },
    hls_to_add_transparency = {
      'MiniFilesBorder',
      'MiniFilesBorderModified',
      'MiniFilesDirectory',
      'MiniFilesFile',
      'MiniFilesNormal',
      'MiniFilesTitle',
      'MiniFilesTitleFocused',
      'MiniClueBorder',
      'MiniClueDescGroup',
      'MiniClueDescSingle',
      'MiniClueNextKey',
      'MiniClueNextKeyWithPostkeys',
      'MiniClueSeparator',
      'MiniClueTitle',
    },
  },
  ---@class Nvim.Modules.Mini.MiniExplorer
  minifiles = {
    config = {
      mappings = {
        show_help = '?',
        go_in = '',
        go_out = '',
        go_in_plus = '<CR>',
        go_out_plus = '-',
      },
    },
    ---@class Nvim.Modules.Mini.MiniExplorer.Functions
    functions = {
      open = function()
        local bufname = vim.api.nvim_buf_get_name(0)
        local path = vim.fn.fnamemodify(bufname, ':p')
        if path and vim.uv.fs_stat(path) then require('mini.files').open(bufname, false) end
      end,
    },
  },
  ---@class Nvim.Modules.Mini.MiniClues
  miniclue = {
    config = {
      triggers = {
        -- Builtins.
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = '`' },
        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },
        { mode = 'n', keys = '<C-w>' },
        { mode = 'i', keys = '<C-x>' },
        { mode = 'n', keys = 'z' },
        -- Leader triggers.
        { mode = 'n', keys = '<leader>' },
        { mode = 'x', keys = '<leader>' },
        -- Moving between stuff.
        { mode = 'n', keys = '[' },
        { mode = 'n', keys = ']' },
      },
      clues = {
        -- Leader/movement groups.
        { mode = 'n', keys = '<leader>c', desc = '+Codecompanion' },
        { mode = 'x', keys = '<leader>c', desc = '+Codecompanion' },
        { mode = 'n', keys = '[', desc = '+prev' },
        { mode = 'n', keys = ']', desc = '+next' },
        -- Builtins.
        require('mini.clue').gen_clues.builtin_completion(),
        require('mini.clue').gen_clues.g(),
        require('mini.clue').gen_clues.marks(),
        require('mini.clue').gen_clues.registers(),
        require('mini.clue').gen_clues.windows(),
        require('mini.clue').gen_clues.z(),
      },
      window = {
        delay = 500,
        scroll_down = '<C-f>',
        scroll_up = '<C-b>',
        config = {
          width = 'auto',
        },
      },
    },
  },
}

if not vim.loop.fs_stat(minipath) then
  vim.fn.system(M.clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup()

MiniDeps.add({ name = 'mini.nvim' })

require('mini.notify').setup()
require('mini.doc').setup()
require('mini.icons').setup()
require('mini.misc').setup()
require('mini.diff').setup()
require('mini.git').setup()

vim.notify = require('mini.notify').make_notify()
vim.ui.select = require('mini.pick').ui_select

local hues, colors = require('mini.hues'), require('mini.colors')
local palette = hues.make_palette(M.theme.palette)
hues.apply_palette(palette)
colors.get_colorscheme():add_transparency(M.theme.transparency):apply()

for _, hl in ipairs(M.theme.hls_to_add_transparency) do
  builtin.override_highlight(hl, { bg = 'none' })
end

require('mini.files').setup(M.minifiles.config)
bind.nmap('-', M.minifiles.functions.open, 'Open file explorer')

require('mini.keymap').setup()
require('mini.keymap').map_multistep('i', '<C-n>', { 'blink_next', 'pmenu_next' })
require('mini.keymap').map_multistep('i', '<C-p>', { 'blink_prev', 'pmenu_prev' })
require('mini.keymap').map_multistep('i', '<Tab>', { 'blink_next', 'pmenu_next' })
require('mini.keymap').map_multistep('i', '<S-Tab>', { 'blink_prev', 'pmenu_prev' })
require('mini.keymap').map_multistep('i', '<CR>', { 'blink_accept', 'pmenu_accept' })
require('mini.keymap').map_combo({ 'i', 'c', 'x', 's' }, 'jk', '<BS><BS><Esc>')
require('mini.keymap').map_combo({ 'i', 'c', 'x', 's' }, 'kj', '<BS><BS><Esc>')
require('mini.keymap').map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
require('mini.keymap').map_combo('t', 'kj', '<BS><BS><C-\\><C-n>')

vim.schedule(function() require('mini.clue').setup(M.miniclue.config) end)
