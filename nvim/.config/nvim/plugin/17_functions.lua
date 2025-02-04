_G.Cargo = function(params)
  Later(function() Utils.Build(params, { 'cargo', 'build', '--release' }) end)
end

_G.LSP = function(picker)
  return function()
    Snacks.picker['lsp_' .. picker]({
      include_current = true,
      auto_confirm = false,
      jump = { reuse_win = false },
    })
  end
end

_G.Autoformat = {
  name = 'Autoformat',
  get = function() return vim.g.autoformat end,
  set = function(e)
    if e then
      vim.g.autoformat = true
    else
      vim.g.autoformat = false
    end
  end,
}

_G.Explorer = function()
  Snacks.picker.explorer({
    auto_close = true,
    jump = { close = true },
    layout = { preset = 'default', preview = true },
  })
end

_G.Scopes = function()
  local widgets = require('dap.ui.widgets')
  widgets.sidebar(widgets.scopes, {}, 'vsplit').toggle()
end
