vim.ui.select = function(items, opts, on_choice)
    local start_opts = { window = { config = { width = vim.o.columns } } }
    return MiniPick.ui_select(items, opts, on_choice, start_opts)
end
