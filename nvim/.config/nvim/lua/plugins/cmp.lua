MiniDeps.add('hrsh7th/nvim-cmp')
MiniDeps.add('hrsh7th/cmp-nvim-lua')
MiniDeps.add('hrsh7th/cmp-nvim-lsp')
MiniDeps.add('hrsh7th/cmp-path')
MiniDeps.add('hrsh7th/cmp-buffer')
MiniDeps.add('hrsh7th/cmp-nvim-lsp-signature-help')

local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args) vim.snippet.expand(args.body) end,
  },
  fields = { 'kind', 'abbr', 'menu' },
  preselect = cmp.PreselectMode.None,
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping({
      i = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        else
          fallback()
        end
      end,
      -- s = cmp.mapping.confirm({ select = false }),
      -- c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
    }),
  }),
  enabled = function()
    -- disable completion in comments
    local context = require('cmp.config.context')
    -- keep command mode completion enabled when cursor is in a comment
    if vim.api.nvim_get_mode().mode == 'c' then
      return true
    else
      return not context.in_treesitter_capture('comment') and not context.in_syntax_group('Comment')
    end
  end,
  sources = cmp.config.sources({
    {
      name = 'nvim_lsp',
      max_item_count = 5,
      entry_filter = function(entry)
        local kind = require('cmp.types').lsp.CompletionItemKind[entry:get_kind()]
        return kind ~= 'Text' and kind ~= 'Snippet'
      end,
    },
    { name = 'nvim_lua', max_item_count = 5 },
    { name = 'nvim_lsp_signature_help', max_item_count = 5 },
  }, {
    { name = 'buffer', max_item_count = 5 },
    { name = 'path', max_item_count = 5 },
  }),
})
