MiniDeps.add('hrsh7th/cmp-nvim-lsp')
MiniDeps.add('hrsh7th/cmp-buffer')
MiniDeps.add('hrsh7th/cmp-path')
MiniDeps.add('hrsh7th/cmp-nvim-lua')
MiniDeps.add('hrsh7th/nvim-cmp')

local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args) vim.snippet.expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping({
      i = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        else
          fallback()
        end
      end,
    }),
  }),
  sources = cmp.config.sources({
    {
      name = 'nvim_lsp',
      entry_filter = function(entry)
        local kind = require('cmp.types').lsp.CompletionItemKind[entry:get_kind()]
        return kind ~= 'Text' and kind ~= 'Snippet'
      end,
    },
    { name = 'path' },
    { name = 'nvim_lua' },
  }, {
    { name = 'buffer' },
  }),
})
