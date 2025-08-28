MiniDeps.add({
  source = 'Saghen/blink.cmp',
  checkout = 'v1.6.0',
  monitor = 'main',
})

require('blink.cmp').setup({
  completion = {
    list = { selection = { preselect = false, auto_insert = true }, max_items = 10 },
    documentation = { auto_show = true },
  },
  cmdline = { enabled = false },
})
