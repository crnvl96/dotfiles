Add('saghen/blink.compat')

require('blink.compat').setup()

local cargo = function(params)
  Later(function() Utils.Build(params, { 'cargo', 'build', '--release' }) end)
end

Add({ source = 'Saghen/blink.cmp', hooks = { post_install = cargo, post_checkout = cargo } })

require('blink.cmp').setup({
  enabled = function()
    return not vim.tbl_contains({ 'minifiles' }, vim.bo.filetype)
      and vim.bo.buftype ~= 'prompt'
      and vim.b.completion ~= false
  end,
  appearance = {
    use_nvim_cmp_as_default = false,
    nerd_font_variant = 'mono',
  },
  snippets = { preset = 'mini_snippets' },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  completion = {
    ghost_text = {
      enabled = false,
    },
    list = {
      selection = {
        preselect = function(ctx) return ctx.mode ~= 'cmdline' end,
        auto_insert = function(ctx) return ctx.mode == 'cmdline' end,
      },
    },
    menu = {
      border = 'rounded',
      scrollbar = false,
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
      window = {
        border = 'rounded',
        scrollbar = false,
      },
    },
  },
  signature = {
    enabled = true,
    window = { border = 'rounded' },
  },
})
