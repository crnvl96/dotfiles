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
