-- Plugins under development ================================================================

-- vim.cmd([[set rtp+=~/Developer/personal/lazydocker.nvim/]])

MiniDeps.add('crnvl96/lazydocker.nvim')

require('lazydocker').setup()

vim.keymap.set('n', '<LocalLeader>a', '<Cmd>lua require("lazydocker").open({engine="docker"})<CR>')

-- Utilities ================================================================

require('mini.misc').setup()
require('mini.doc').setup()

-- Theme ================================================================
require('mini.icons').setup()

vim.cmd.colorscheme('miniwinter')

require('mini.colors')
  .get_colorscheme()
  :add_transparency({
    float = true,
    statuscolumn = true,
    statusline = true,
    tabline = true,
    winbar = true,
  })
  :apply()

-- Sleuth ================================================================

MiniDeps.add('tpope/vim-sleuth')

-- Unnest ================================================================

MiniDeps.add('brianhuster/unnest.nvim')

-- Fugitive ================================================================

MiniDeps.add('tpope/vim-fugitive')

-- Mini.pick ================================================================

MiniDeps.add({ source = 'dmtrKovalenko/fff.nvim', hooks = {
  post_install = Build,
  post_checkout = Build,
} })

require('fff').setup({ prompt = '🪿 ' })

vim.keymap.set('n', '<Leader>f', function() require('fff').find_files() end, { desc = 'FFFind files' })

-- Blink.cmp ================================================================

MiniDeps.add({
  source = 'Saghen/blink.cmp',
  checkout = 'v1.6.0',
  monitor = 'main',
})

require('blink.cmp').setup({
  completion = {
    list = { selection = { preselect = false, auto_insert = true }, max_items = 10 },
    documentation = { auto_show = true },
  },
  cmdline = { enabled = false },
})

-- Conform ================================================================

MiniDeps.add('stevearc/conform.nvim')

local conform = require('conform')
local get_root = require('conform.util').root_file

local function get_web_formatter()
  return get_root({ 'biome.json', 'biome.jsonc' }) and { 'biome', 'biome-check', 'biome-organize-imports' }
    or { 'prettier' }
end

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.g.autoformat = true

conform.setup({
  notify_on_error = true,
  formatters = { injected = { ignore_errors = true } },
  formatters_by_ft = {
    ['_'] = { 'trim_whitespace', 'trim_newlines' },
    json = { 'jq' },
    jsonc = { 'jq' },
    css = get_web_formatter,
    javascript = get_web_formatter,
    javascriptreact = get_web_formatter,
    typesCRipt = get_web_formatter,
    typescriptreact = get_web_formatter,
    lua = { 'stylua' },
    markdown = { 'injected' },
    toml = function()
      local root = get_root({ 'pyproject.toml' })
      return root and { 'pyproject-fmt' } or { 'taplo' }
    end,
    python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
    rust = { 'rustfmt' },
  },
  format_on_save = function() return vim.g.autoformat and { timeout_ms = 3000, lsp_format = 'fallback' } end,
})

vim.api.nvim_create_user_command('ToggleFormat', function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify(string.format('%s formatting...', vim.g.autoformat and 'Enabling' or 'Disabling'), vim.log.levels.INFO)
end, { desc = 'Toggle conform.nvim auto-formatting', nargs = 0 })

-- Mini.files ================================================================

local files = require('mini.files')
files.setup({
  mappings = {
    show_help = '?',
    go_in = '',
    go_out = '',
    go_in_plus = '<CR>',
    go_out_plus = '-',
  },
})

vim.keymap.set('n', '-', function()
  local bufname = vim.api.nvim_buf_get_name(0)
  local path = vim.fn.fnamemodify(bufname, ':p')
  if path and vim.uv.fs_stat(path) then files.open(bufname, false) end
end)

for _, hl in ipairs({
  'MiniFilesBorder',
  'MiniFilesBorderModified',
  'MiniFilesDirectory',
  'MiniFilesFile',
  'MiniFilesNormal',
  'MiniFilesTitle',
  'MiniFilesTitleFocused',
}) do
  CustomHL(hl, { bg = 'none' })
end

-- Grug-far ================================================================

MiniDeps.add('MagicDuck/grug-far.nvim')

require('grug-far').setup({
  transient = true,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('crnvl96-grug-far-keybindings', { clear = true }),
  pattern = { 'grug-far' },
  callback = function()
    vim.keymap.set('n', '<C-enter>', function()
      require('grug-far').get_instance(0):open_location()
      require('grug-far').get_instance(0):close()
    end, { buffer = true })
  end,
})

vim.keymap.set(
  'n',
  '<Leader>g',
  function()
    require('grug-far').toggle_instance({
      instanceName = 'far',
      staticTitle = 'Find and Replace',
    })
  end,
  { desc = 'Live grep' }
)

vim.keymap.set(
  'n',
  '<Leader>l',
  function()
    require('grug-far').toggle_instance({
      instanceName = 'far',
      staticTitle = 'Find and Replace',
      prefills = { paths = vim.fn.expand('%') },
    })
  end
)

-- Snacks ================================================================

MiniDeps.add('folke/snacks.nvim')

require('snacks').setup({
  terminal = { win = { border = 'single' } },
  styles = {
    terminal = { height = 0.95, width = 0.95 },
    lazygit = { height = 0.95, width = 0.95 },
  },
})

vim.keymap.set({ 'n', 't' }, '<C-t>', function() Snacks.terminal() end, { desc = 'Terminal' })
vim.keymap.set({ 'n', 't' }, '<C-a>', function() Snacks.terminal('opencode') end, { desc = 'Terminal' })

if vim.fn.executable('lazygit') == 1 then
  vim.keymap.set('n', '<leader>s', function() Snacks.lazygit() end, { desc = 'Lazygit' })
end

-- OpenCode ================================================================

MiniDeps.add('NickvanDyke/opencode.nvim')

local o = require('opencode')
o.setup()

vim.keymap.set('n', '<leader>oo', function() o.ask() end, { desc = 'Ask opencode' })
vim.keymap.set('v', '<leader>oo', function() o.ask('@selection: ') end, { desc = 'Ask opencode' })
vim.keymap.set('n', '<leader>ot', function() o.toggle() end, { desc = 'Toggle opencode' })
vim.keymap.set('n', '<leader>on', function() o.command('session_new') end, { desc = 'New session' })
vim.keymap.set('n', '<leader>oy', function() o.command('messages_copy') end, { desc = 'Copy last message' })
vim.keymap.set('n', '<S-C-u>', function() o.command('messages_half_page_up') end, { desc = 'Scroll messages up' })
vim.keymap.set('n', '<S-C-d>', function() o.command('messages_half_page_down') end, { desc = 'Scroll messages down' })
vim.keymap.set({ 'n', 'v' }, '<leader>op', function() o.select_prompt() end, { desc = 'Select prompt' })

-- Mini.keymaps ================================================================

local map = require('mini.keymap')

map.setup()

map.map_multistep('i', '<C-n>', { 'blink_next', 'pmenu_next' })
map.map_multistep('i', '<C-p>', { 'blink_prev', 'pmenu_prev' })
map.map_multistep('i', '<Tab>', { 'blink_next', 'pmenu_next' })
map.map_multistep('i', '<S-Tab>', { 'blink_prev', 'pmenu_prev' })
map.map_multistep('i', '<CR>', { 'blink_accept', 'pmenu_accept' })
map.map_combo({ 'i', 'c', 'x', 's' }, 'jk', '<BS><BS><Esc>')
map.map_combo({ 'i', 'c', 'x', 's' }, 'kj', '<BS><BS><Esc>')
map.map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
map.map_combo('t', 'kj', '<BS><BS><C-\\><C-n>')
