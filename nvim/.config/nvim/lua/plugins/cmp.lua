local add = MiniDeps.add

add('hrsh7th/cmp-nvim-lsp')
add('hrsh7th/cmp-buffer')
add('hrsh7th/cmp-path')
add('hrsh7th/cmp-nvim-lua')
add('hrsh7th/nvim-cmp')

local cmp = require('cmp')
local bh_insert = { behavior = cmp.SelectBehavior.Insert }
local bh_replace = { behavior = cmp.ConfirmBehavior.Replace, select = false }

cmp.setup({
  snippet = {
    expand = function(args) vim.snippet.expand(args.body) end,
  },
  preselect = cmp.PreselectMode.None,
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(bh_insert),
    ['<C-n>'] = cmp.mapping.select_next_item(bh_insert),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping({
      i = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
          cmp.confirm(bh_replace)
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
