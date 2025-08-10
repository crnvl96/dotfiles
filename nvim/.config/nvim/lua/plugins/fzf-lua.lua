MiniDeps.later(function()
  MiniDeps.add('ibhagwan/fzf-lua')

  local actions = require('fzf-lua').actions
  require('fzf-lua').setup({
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

  require('fzf-lua').register_ui_select()

  vim.keymap.set('n', '<Leader>f', function() require('fzf-lua').files() end)
  vim.keymap.set('n', '<Leader>l', function() require('fzf-lua').blines() end)
  vim.keymap.set('n', '<Leader>g', function() require('fzf-lua').live_grep() end)
  vim.keymap.set('x', '<Leader>g', function() require('fzf-lua').grep_visual() end)
  vim.keymap.set({ 'n', 't' }, '<C-t>', function() require('fzf-lua').buffers() end)
  vim.keymap.set('n', "<Leader>'", function() require('fzf-lua').resume() end)
  vim.keymap.set('n', '<Leader>x', function() require('fzf-lua').quickfix() end)
end)
