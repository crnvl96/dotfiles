MiniDeps.later(function()
  local function build(params)
    vim.notify('Building blink.cmp', vim.log.levels.INFO)
    local out = vim.system({ 'cargo', '+nightly', 'build', '--release' }, { cwd = params.path }):wait()
    if out.code == 0 then return vim.notify('Building blink.cmp done', vim.log.levels.INFO) end
    return vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
  end

  MiniDeps.add({
    source = 'Saghen/blink.cmp',
    hooks = { post_install = build, post_checkout = build },
  })

  require('blink.cmp').setup({
    completion = {
      list = {
        selection = { preselect = false, auto_insert = true },
        max_items = 10,
      },
      documentation = { auto_show = true },
    },
    cmdline = {
      enabled = true,
      keymap = { preset = 'inherit' },
      completion = { menu = { auto_show = true } },
    },
  })
end)
