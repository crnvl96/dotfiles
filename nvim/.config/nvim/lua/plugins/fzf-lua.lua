MiniDeps.later(function()
  MiniDeps.add('ibhagwan/fzf-lua')

  local fzf_lua = require('fzf-lua')
  local actions = fzf_lua.actions

  fzf_lua.setup({
    'border-fused',
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
      height = 0.4,
      width = 0.4,
      row = 0.5,
      col = 0.5,
      border = 'single',
      preview = {
        hidden = true,
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

  set('n', '<Leader>f', '<Cmd>FzfLua files<CR>', { desc = 'Find files' })
end)
