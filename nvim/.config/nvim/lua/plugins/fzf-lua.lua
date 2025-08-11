MiniDeps.later(function()
  MiniDeps.add('ibhagwan/fzf-lua')

  local fzf_lua = require('fzf-lua')
  local actions = fzf_lua.actions

  fzf_lua.setup({
    { 'border-fused', 'hide' },
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
      border = 'single',
      preview = {
        vertical = 'down:45%',
        horizontal = 'right:60%',
        layout = 'flex',
        flip_columns = 150,
        scrollbar = false,
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

  fzf_lua.register_ui_select()

  local set = vim.keymap.set
  local function feed(key) vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), 't', true) end

  set('n', '<Leader>f', '<Cmd>FzfLua files<CR>', { desc = 'Find files' })
  set('n', '<Leader>l', '<Cmd>FzfLua blines<CR>', { desc = 'Search in buffer lines' })
  set('n', '<Leader>g', '<Cmd>FzfLua live_grep<CR>', { desc = 'Live grep' })
  set('n', "<Leader>'", '<Cmd>FzfLua resume<CR>', { desc = 'Resume last picker' })
  set('n', '<M-g>', '<Cmd>FzfLua buffers<CR>', { desc = 'List buffers' })

  set('t', '<M-g>', function()
    feed('<C-\\><C-n>')
    fzf_lua.buffers()
  end)
end)
