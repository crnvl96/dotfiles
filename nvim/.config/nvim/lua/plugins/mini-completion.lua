require('mini.completion').setup({
  delay = {
    -- completion = 10 ^ 7,
    completion = 100,
    info = 100,
    signature = 50,
  },
  lsp_completion = {
    source_func = 'omnifunc',
    auto_setup = false,
    process_items = function(items, base)
      items = vim.tbl_filter(function(x) return x.kind ~= 1 and x.kind ~= 15 end, items)
      -- return require('mini.completion').default_process_items(items, base)
      return require('mini.fuzzy').process_lsp_items(items, base)
    end,
  },
  window = {
    info = { border = 'double' },
    signature = { border = 'double' },
  },
  mappings = {
    force_twostep = '<C-n>',
    force_fallback = '<A-Space>',
  },
})

local keycode = vim.keycode or function(x) return vim.api.nvim_replace_termcodes(x, true, true, true) end
local keys = {
  ['cr'] = keycode('<CR>'),
  ['ctrl-y'] = keycode('<C-y>'),
  ['ctrl-y_cr'] = keycode('<C-y><CR>'),
}

_G.cr_action = function()
  if vim.fn.pumvisible() ~= 0 then
    local item_selected = vim.fn.complete_info()['selected'] ~= -1
    return item_selected and keys['ctrl-y'] or keys['ctrl-y_cr']
  else
    return keys['cr']
  end
end

vim.keymap.set('i', '<CR>', 'v:lua._G.cr_action()', { expr = true })
