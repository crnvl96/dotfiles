local c = require('utils.constants')

require('nvim-treesitter').install(c.ts_tools)

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('crnvl96-treesitter', {}),
  callback = function(e)
    local filetype = e.match
    local lang = vim.treesitter.language.get_lang(filetype) or ''

    if vim.treesitter.language.add(lang) then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.treesitter.start()
    end
  end,
})
