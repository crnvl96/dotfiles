function _G.statusline_diagnostics()
    local diagnostics = vim.diagnostic.get(0)
    local counts = { 0, 0, 0, 0 }

    for _, diagnostic in ipairs(diagnostics) do
        counts[diagnostic.severity] = counts[diagnostic.severity] + 1
    end

    local icons = { 'E:', 'W:', 'I:', 'H:' }
    local result = {}

    for i, count in ipairs(counts) do
        if count > 0 then table.insert(result, icons[i] .. count) end
    end

    return #result > 0 and table.concat(result, ' ') or ''
end

vim.opt.statusline = table.concat({
    ' %f', -- File path
    ' %m%r%h%w', -- File flags (modified, readonly, etc.)
    ' %{%v:lua.statusline_diagnostics()%}', -- Diagnostics
    '%=', -- Right align the rest
    '%{%v:lua.codecompanion_statusline()%}', -- CodeCompanion status
    ' %y', -- File type
    ' %l:%c ', -- Line and column
    ' %p%% ', -- Percentage through file
}, '')
