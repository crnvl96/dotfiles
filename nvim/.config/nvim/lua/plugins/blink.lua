MiniDeps.later(function()
  local function build(params)
    vim.notify('Building blink.cmp', vim.log.levels.INFO)
    local out = vim.system({ 'cargo', 'build', '--release' }, { cwd = params.path }):wait()
    if out.code == 0 then return vim.notify('Building blink.cmp done', vim.log.levels.INFO) end
    return vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
  end

  local hooks = { post_install = build, post_checkout = build }

  MiniDeps.add({ source = 'Saghen/blink.cmp', hooks = hooks })

  require('blink.cmp').setup({
    cmdline = {
      keymap = { preset = 'inherit' },
      completion = { menu = { auto_show = true } },
    },
  })
end)
