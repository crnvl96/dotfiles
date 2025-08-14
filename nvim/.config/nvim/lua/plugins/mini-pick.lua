MiniDeps.later(function()
  require('mini.pick').setup({
    {
      mappings = {
        caret_left = '<Left>',
        caret_right = '<Right>',

        choose = '<CR>',
        choose_in_split = '<C-s>',
        choose_in_tabpage = '<C-t>',
        choose_in_vsplit = '<C-v>',
        choose_marked = '<M-CR>',

        delete_char = '<BS>',
        delete_char_right = '<Del>',
        delete_left = '<C-u>',
        delete_word = '<C-w>',

        mark = '<C-x>',
        mark_all = '<C-a>',

        move_down = '<C-n>',
        move_start = '<C-g>',
        move_up = '<C-p>',

        paste = '<C-r>',

        refine = '<C-Space>',
        refine_marked = '<M-Space>',

        scroll_down = '<C-f>',
        scroll_left = '<C-h>',
        scroll_right = '<C-l>',
        scroll_up = '<C-b>',

        stop = '<Esc>',

        toggle_info = '<S-Tab>',
        toggle_preview = '<Tab>',
      },
      options = {
        use_cache = true,
      },
      window = {
        config = nil,
        prompt_caret = '▏',
        prompt_prefix = '> ',
      },
    },
  })

  vim.ui.select = require('mini.pick').ui_select

  vim.keymap.set('n', '<Leader>f', '<Cmd>Pick files<CR>', { desc = 'Find files' })
  vim.keymap.set('n', '<C-6>', '<Cmd>Pick buffers<CR>', { desc = 'Find files' })

  local function list_bufs()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, true, true), 't', true)
    require('mini.pick').builtin.buffers()
  end

  vim.keymap.set('t', '<C-6>', list_bufs, { desc = 'List buffers' })
end)
