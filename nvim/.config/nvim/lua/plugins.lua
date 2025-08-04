---
--- Plugins
---

MiniDeps.now(function()
  MiniDeps.add({ name = 'mini.nvim' })
  MiniDeps.add('neovim/nvim-lspconfig')
  MiniDeps.add('tpope/vim-fugitive')
end)

---
--- Mason
---

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
        'gopls',
        'biome',
        'css-lsp', -- cssls
        'eslint-lsp', -- eslint
        'lua-language-server', -- lua_ls
        'pyright',
        'ruff',
        'typescript-language-server', -- ts_ls
        'tailwindcss-language-server', -- tailwindcss
        'jq', -- json
      }) do
        local p = mr.get_package(tool)
        if not p:is_installed() then p:install() end
      end
    end)
  end)
end)

---
--- Treesitter
---

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
    'jsx',
    'python',
    'rust',
  }

  require('nvim-treesitter').install(parsers)

  local group = vim.api.nvim_create_augroup('crnvl96-treesitter', {})

  local callback = function(e)
    local filetype = e.match
    local lang = vim.treesitter.language.get_lang(filetype) or ''
    if vim.treesitter.language.add(lang) then
      vim.bo[e.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.treesitter.start()
    end
  end

  vim.api.nvim_create_autocmd('FileType', { group = group, callback = callback })
end)

---
--- Conform.nvim - code formatter
---

MiniDeps.later(function()
  MiniDeps.add('stevearc/conform.nvim')

  local function get_root_dir(root_files, bufnr)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    return vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1])
  end

  local function get_web_formatter(bufnr)
    if get_root_dir({ 'biome.json', 'biome.jsonc' }, bufnr) then
      return { 'biome', 'biome-check', 'biome-organize-imports' }
    else
      return { 'prettier' }
    end
  end

  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  vim.g.conform = true

  require('conform').setup({
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
      markdown = { 'prettier', 'injected' },
      python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
      rust = { 'rustfmt' },
    },
    format_on_save = function() return vim.g.conform and { timeout_ms = 3000, lsp_format = 'fallback' } end,
  })
end)

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
