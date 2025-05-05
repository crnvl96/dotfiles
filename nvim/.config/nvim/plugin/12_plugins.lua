local add = MiniDeps.add
local now = MiniDeps.now
local later = MiniDeps.later
local set = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local au = vim.api.nvim_create_augroup

now(function()
  add { name = 'mini.nvim' }
  add 'nvim-lua/plenary.nvim'
  add 'neovim/nvim-lspconfig'
  require('mini.icons').setup()
end)

now(function()
  add 'nvim-treesitter/nvim-treesitter'

  require('nvim-treesitter.configs').setup {
    ensure_installed = {
      'c',
      'lua',
      'vim',
      'vimdoc',
      'query',
      'markdown',
      'markdown_inline',
      'javascript',
      'typescript',
      'tsx',
      'ruby',
      'python',
    },
    sync_install = false,
    ignore_install = {},
    highlight = { enable = true },
    indent = {
      enable = true,
      disable = { 'yaml' },
    },
  }
end)

later(function()
  add 'tpope/vim-dadbod'
  add 'kristijanhusak/vim-dadbod-ui'
  add 'tpope/vim-fugitive'
  add 'tpope/vim-rhubarb'
  add 'tpope/vim-sleuth'
  add 'mbbill/undotree'
  add 'christoomey/vim-tmux-navigator'

  set('n', '<C-h>', '<Cmd>TmuxNavigateLeft<CR>')
  set('n', '<C-j>', '<Cmd>TmuxNavigateDown<CR>')
  set('n', '<C-k>', '<Cmd>TmuxNavigateUp<CR>')
  set('n', '<C-l>', '<Cmd>TmuxNavigateRight<CR>')
end)

later(function()
  add 'mfussenegger/nvim-dap'
  add 'suketa/nvim-dap-ruby'

  require('dap-ruby').setup()

  local widgets = require 'dap.ui.widgets'

  set('n', '<leader>db', require('dap').toggle_breakpoint)
  set('n', '<leader>dc', require('dap').continue)
  set('n', '<leader>dt', require('dap').terminate)
  set('n', '<Leader>dr', require('dap').repl.toggle)
  set({ 'n', 'v' }, '<Leader>dh', require('dap.ui.widgets').hover)

  set('n', '<Leader>df', function()
    widgets.sidebar(widgets.frames).open()
  end)

  set('n', '<Leader>ds', function()
    widgets.sidebar(widgets.scopes).open()
  end)
end)

later(function()
  add 'ibhagwan/fzf-lua'

  require('fzf-lua').setup {
    fzf_opts = {
      ['--cycle'] = '',
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
  }

  vim.ui.select = function(items, opts, on_choice)
    if not require('fzf-lua.providers.ui_select').is_registered() then
      require('fzf-lua.providers.ui_select').register()
    end

    if #items > 0 then
      return vim.ui.select(items, opts, on_choice)
    end
  end

  set('n', '<Leader>f', function()
    require('fzf-lua').files()
  end)

  set('n', '<Leader>l', function()
    require('fzf-lua').blines()
  end)

  set('n', '<Leader>g', function()
    require('fzf-lua').live_grep()
  end)

  set('x', '<Leader>g', function()
    require('fzf-lua').grep_visual()
  end)

  set('n', '<Leader>b', function()
    require('fzf-lua').buffers()
  end)

  set('n', '<Leader>\'', function()
    require('fzf-lua').resume()
  end)

  set('n', '<Leader>x', function()
    require('fzf-lua').quickfix()
  end)
end)

later(function()
  local minifiles = require 'mini.files'

  local function map_split(bufnr, lhs, direction)
    local function rhs()
      local window = minifiles.get_explorer_state().target_window
      if window == nil or minifiles.get_fs_entry().fs_type == 'directory' then
        return
      end

      local new_target_window
      vim.api.nvim_win_call(window, function()
        vim.cmd(direction .. ' split')
        new_target_window = vim.api.nvim_get_current_win()
      end)

      minifiles.set_target_window(new_target_window)
      minifiles.go_in { close_on_file = true }
    end

    vim.keymap.set(
      'n',
      lhs,
      rhs,
      { buffer = bufnr, desc = 'Split ' .. string.sub(direction, 12) }
    )
  end

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    group = vim.api.nvim_create_augroup('crnvl96-minifiles', {}),
    callback = function(args)
      local bufnr = args.data.buf_id
      map_split(bufnr, '<C-w>s', 'belowright horizontal')
      map_split(bufnr, '<C-w>v', 'belowright vertical')
    end,
  })

  vim.keymap.set('n', '-', function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local path = vim.fn.fnamemodify(bufname, ':p')
    if path and vim.uv.fs_stat(path) then
      minifiles.open(bufname, false)
    end
  end)

  minifiles.setup {
    mappings = {
      show_help = '?',
      go_in_plus = '<CR>',
      go_out_plus = '-',
      go_in = '',
      go_out = '',
    },
  }
end)

later(function()
  add 'stevearc/conform.nvim'

  vim.o.formatexpr = 'v:lua.require\'conform\'.formatexpr()'
  vim.g.conform = true

  require('conform').setup {
    notify_on_error = true,
    formatters = {
      injected = {
        ignore_errors = true,
      },
    },
    formatters_by_ft = {
      ['_'] = { 'trim_whitespace', 'trim_newlines' },
      lua = { 'stylua' },
      json = { 'prettier' },
      markdown = { 'prettier', 'injected' },
      python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },

      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      javascript = { lsp_format = 'prefer' },
      css = { 'prettier' },

      ruby = { 'rubocop' },
      eruby = { 'rubocop' },
    },
    format_on_save = function()
      return vim.g.conform and { timeout_ms = 3000, lsp_format = 'fallback' }
    end,
  }
end)

later(function()
  add 'mfussenegger/nvim-lint'

  local lint = require 'lint'

  lint.linters_by_ft = {
    css = { 'stylelint' },
  }

  autocmd({ 'BufWritePost', 'InsertLeave', 'TextChanged' }, {
    group = au('crnvl96-try-lint', {}),
    callback = function()
      lint.try_lint()
    end,
  })
end)
