_G.Utils = {}

local function swap_mark_case(key)
    if key:match('%u') then
        return key:lower()
    elseif key:match('%l') then
        return key:upper()
    else
        return key
    end
end

Utils.Group = function(name, fn) fn(vim.api.nvim_create_augroup(name, { clear = true })) end

Utils.Abbr = function(abbr, cmd)
    local expand = function() return (vim.fn.getcmdtype() == ':' and vim.fn.getcmdline() == abbr) and cmd or abbr end
    vim.keymap.set('ca', abbr, expand, { expr = true })
end

Utils.ExpandCallable = function(x, ...)
    if vim.is_callable(x) then return x(...) end
    return x
end

Utils.LoadFile = function(f)
    local path = vim.fn.stdpath('config') .. '/static/api_keys/' .. f
    local file = io.open(path, 'r')
    if file then
        local key = file:read('*a'):gsub('%s+$', '')
        file:close()
        if not key then
            vim.notify('Missing file: ' .. f, 'ERROR')
            return nil
        end
        return key
    end
    return nil
end

Utils.Build = function(p, cmd)
    vim.notify('Building ' .. p.name, vim.log.levels.INFO)

    local obj = vim.system(cmd, { cwd = p.path }):wait()

    if obj.code == 0 then
        vim.notify('Finished building ' .. p.name, vim.log.levels.INFO)
    else
        vim.notify('Failed building' .. p.name, vim.log.levels.ERROR)
    end
end

Utils.MiniDepsHooks = function()
    return {
        treesitter = {
            post_install = function()
                MiniDeps.later(function() vim.cmd('TSUpdate') end)
            end,
            post_checkout = function()
                MiniDeps.later(function() vim.cmd('TSUpdate') end)
            end,
        },
        blink = {
            post_install = function(p)
                MiniDeps.later(function() Utils.Build(p, { 'cargo', 'build', '--release' }) end)
            end,
            post_checkout = function(p)
                MiniDeps.later(function() Utils.Build(p, { 'cargo', 'build', '--release' }) end)
            end,
        },
        vectorcode = {
            post_install = function(p)
                MiniDeps.later(function() Utils.Build(p, { 'uv', 'tool', 'install', '--upgrade', 'vectorcode' }) end)
            end,
            post_checkout = function(p)
                MiniDeps.later(function() Utils.Build(p, { 'uv', 'tool', 'install', '--upgrade', 'vectorcode' }) end)
            end,
        },
        mcphub = {
            post_install = function(p)
                MiniDeps.later(function() Utils.Build(p, { 'npm', 'install', '-g', 'mcp-hub@latest' }) end)
            end,
            post_checkout = function(p)
                MiniDeps.later(function() Utils.Build(p, { 'npm', 'install', '-g', 'mcp-hub@latest' }) end)
            end,
        },
    }
end

Utils.ReadFromFile = function(f)
    local path = vim.fn.stdpath('config') .. '/static/api_keys/' .. f
    local file = io.open(path, 'r')

    if file then
        local key = file:read('*a'):gsub('%s+$', '')
        file:close()

        if not key then
            vim.notify('Missing file: ' .. f, 'ERROR')
            return nil
        end

        return key
    end

    return nil
end

Utils.OnAttach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    local set = vim.keymap.set

    set('n', 'E', '<Cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'Eval', buffer = bufnr })
    set('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', { desc = 'Eval', buffer = bufnr })
    set('n', '<Leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'Actions', buffer = bufnr })
    set('n', '<Leader>ln', '<Cmd>lua vim.lsp.buf.rename()<CR>', { desc = 'Rename', buffer = bufnr })

    set('n', '<Leader>ld', '<Cmd>FzfLua lsp_definitions<CR>', { desc = 'Goto Definition' })
    set('n', '<Leader>lD', '<Cmd>FzfLua lsp_declarations<CR>', { desc = 'Goto Declaration' })
    set('n', '<Leader>lr', '<Cmd>FzfLua lsp_references<CR>', { nowait = true, desc = 'References' })
    set('n', '<Leader>li', '<Cmd>FzfLua lsp_implementations<CR>', { desc = 'Goto Implementation' })
    set('n', '<Leader>ly', '<Cmd>FzfLua lsp_typedefs<CR>', { desc = 'Goto T[y]pe Definition' })
    set('n', '<Leader>le', '<Cmd>FzfLua lsp_document_diagnostics<CR>', { desc = 'Diagnostics' })
    set('n', '<Leader>ls', '<Cmd>FzfLua lsp_document_symbols<CR>', { desc = 'LSP Symbols' })
    set('n', '<Leader>lS', '<Cmd>FzfLua lsp_workspace_symbols<CR>', { desc = 'LSP Workspace Symbols' })
end

Utils.Marks = {
    set_mark_swapped = function()
        local ok, char = pcall(function() return vim.fn.nr2char(vim.fn.getchar()) end)
        if not ok or char == '' or char == '\27' then -- ESC or error
            return
        end
        local swapped = swap_mark_case(char)
        vim.cmd('normal! m' .. swapped)
    end,

    goto_mark_swapped_quote = function()
        local ok, char = pcall(function() return vim.fn.nr2char(vim.fn.getchar()) end)
        if not ok or char == '' or char == '\27' then return end
        local swapped = swap_mark_case(char)
        vim.cmd("normal! '" .. swapped)
    end,

    goto_mark_swapped_backtick = function()
        local ok, char = pcall(function() return vim.fn.nr2char(vim.fn.getchar()) end)
        if not ok or char == '' or char == '\27' then return end
        local swapped = swap_mark_case(char)
        vim.cmd('normal! `' .. swapped)
    end,
}
