MiniDeps.add({
  source = 'Saghen/blink.cmp',
  checkout = 'v1.6.0',
  monitor = 'main',
})

require('blink.cmp').setup({
  completion = {
    list = {
      selection = { preselect = false, auto_insert = true },
      max_items = 10,
    },
    documentation = {
      auto_show = true,
    },
    menu = {
      draw = {
        columns = {
          { 'kind_icon' },
          { 'label', 'label_description', 'source_name', gap = 1 },
        },
        components = {
          kind_icon = {
            text = function(ctx)
              if ctx.source_id == 'cmdline' then return end
              return ctx.kind_icon .. ctx.icon_gap
            end,
          },
          source_name = {
            text = function(ctx)
              if ctx.source_id == 'cmdline' then return end
              return ctx.source_name:sub(1, 4)
            end,
          },
        },
      },
    },
  },
  cmdline = {
    enabled = false,
  },
  appearande = {
    nerd_font_variant = 'mono',
  },
})
