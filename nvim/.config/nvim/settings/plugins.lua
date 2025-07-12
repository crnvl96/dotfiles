MiniDeps.now(function()
  MiniDeps.add({ name = 'mini.nvim' })
  MiniDeps.add('nvim-lua/plenary.nvim')

  local icons = require('mini.icons')
  icons.setup()
  icons.mock_nvim_web_devicons()

  MiniDeps.add('neovim/nvim-lspconfig')
  MiniDeps.add('tpope/vim-fugitive')
  MiniDeps.add('tpope/vim-rhubarb')
  MiniDeps.add('tpope/vim-sleuth')
  MiniDeps.add('mbbill/undotree')

  require('mini.doc').setup()
end)

MiniDeps.now(function()
  MiniDeps.add({
    source = 'mason-org/mason.nvim',
    hooks = {
      post_checkout = function() vim.cmd('MasonUpdate') end,
    },
  })

  require('mason').setup()

  MiniDeps.later(function()
    local mr = require('mason-registry')

    mr.refresh(function()
      for _, tool in ipairs({
        -- Formatters
        'stylua',
        'prettier',

        -- Language servers
        'biome',
        'css-lsp', -- cssls
        'eslint-lsp', -- eslint
        'lua-language-server', -- lua_ls
        'pyright',
        'rubocop',
        'ruby-lsp', -- ruby_lsp
        'ruff',
        'stimulus-language-server', -- stimulus_ls
        'typescript-language-server', -- ts_ls

        -- Awaiting for a stable release
        'pyrefly', -- https://github.com/facebook/pyrefly
        'ty', -- https://github.com/astral-sh/ty
      }) do
        local p = mr.get_package(tool)
        if not p:is_installed() then p:install() end
      end
    end)
  end)
end)

MiniDeps.now(function()
  MiniDeps.add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'main',
    hooks = {
      post_checkout = function() vim.cmd('TSUpdate') end,
    },
  })

  local parsers = {
    'c',
    'lua',
    'prisma',
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
  }

  require('nvim-treesitter').install(parsers)

  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('crnvl96-treesitter', {}),
    pattern = vim.tbl_deep_extend('force', parsers, { 'codecompanion' }),
    callback = function() vim.treesitter.start() end,
  })
end)

MiniDeps.later(function()
  MiniDeps.add('MagicDuck/grug-far.nvim')

  require('grug-far').setup({})
end)

MiniDeps.later(function()
  MiniDeps.add('stevearc/conform.nvim')

  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  vim.g.conform = true

  local function get_root_dir(root_files, bufnr)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    return vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1])
  end

  require('conform').setup({
    notify_on_error = true,
    formatters = {
      injected = {
        ignore_errors = true,
      },
    },
    formatters_by_ft = {
      ['_'] = { 'trim_whitespace', 'trim_newlines' },
      css = { 'prettier' },
      javascript = function(bufnr)
        local biome_root_files = { 'biome.json', 'biome.jsonc' }

        if get_root_dir(biome_root_files, bufnr) then
          return { 'biome', 'biome-check', 'biome-organize-imports' }
        else
          return { 'prettier' }
        end
      end,
      javascriptreact = function(bufnr)
        local biome_root_files = { 'biome.json', 'biome.jsonc' }

        if get_root_dir(biome_root_files, bufnr) then
          return { 'biome', 'biome-check', 'biome-organize-imports' }
        else
          return { 'prettier' }
        end
      end,
      json = { 'prettier' },
      lua = { 'stylua' },
      markdown = { 'prettier', 'injected' },
      python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
      ruby = { 'rubocop' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
    },
    format_on_save = function() return vim.g.conform and { timeout_ms = 3000, lsp_format = 'fallback' } end,
  })
end)

MiniDeps.later(function()
  MiniDeps.add('mfussenegger/nvim-lint')

  local lint = require('lint')

  lint.linters_by_ft = {}

  vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave', 'TextChanged' }, {
    group = vim.api.nvim_create_augroup('crnvl96-try-lint', {}),
    callback = function() lint.try_lint() end,
  })
end)

MiniDeps.later(function()
  MiniDeps.add('mfussenegger/nvim-dap')
  MiniDeps.add('mfussenegger/nvim-dap-python')

  local widgets = require('dap.ui.widgets')
  local frames = function() widgets.sidebar(widgets.frames).open() end
  local scopes = function() widgets.sidebar(widgets.scopes).open() end

  require('dap-python').setup('uv')
  require('dap-python').test_runner = 'pytest'

  vim.keymap.set('n', '<leader>dpm', require('dap-python').test_method)
  vim.keymap.set('n', '<leader>dpc', require('dap-python').test_class)
  vim.keymap.set('n', '<leader>dps', require('dap-python').debug_selection)

  vim.keymap.set('n', '<leader>db', require('dap').toggle_breakpoint)
  vim.keymap.set('n', '<leader>dc', require('dap').continue)
  vim.keymap.set('n', '<leader>dt', require('dap').terminate)
  vim.keymap.set('n', '<Leader>dr', require('dap').repl.toggle)
  vim.keymap.set({ 'n', 'v' }, '<Leader>dh', require('dap.ui.widgets').hover)
  vim.keymap.set('n', '<Leader>df', frames)
  vim.keymap.set('n', '<Leader>ds', scopes)
end)

dofile(NVIM_DIR .. '/plugins/blink.lua')
dofile(NVIM_DIR .. '/plugins/ai.lua')
dofile(NVIM_DIR .. '/plugins/fzf.lua')
dofile(NVIM_DIR .. '/plugins/minifiles.lua')

-- MiniDeps.later(function()
-- 	vim.cmd("set rtp+=~/Developer/personal/lazydocker.nvim/")
-- 	require("lazydocker").setup({
-- 		window = {
-- 			settings = {
-- 				width = 0.9,
-- 				height = 0.9,
-- 			},
-- 		},
-- 	})
-- 	vim.keymap.set({ "n", "t" }, "<leader>zz", "<Cmd>lua LazyDocker.toggle()<CR>")
-- 	vim.keymap.set({ "n", "t" }, "<leader>zp", "<Cmd>lua LazyDocker.toggle({engine='podman'})<CR>")
-- end)
