_G.Utils = {}

Utils.Group = function(name, fn) fn(vim.api.nvim_create_augroup(name, { clear = true })) end

Utils.ExpandCallable = function(x, ...)
    if vim.is_callable(x) then return x(...) end
    return x
end

Utils.LoadFile = function(f)
    local path = vim.fn.stdpath('config') .. '/static/files/' .. f
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

Utils.MiniDepsBuild = function(p, cmd)
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
                MiniDeps.later(function() Utils.MiniDepsBuild(p, { 'cargo', 'build', '--release' }) end)
            end,
            post_checkout = function(p)
                MiniDeps.later(function() Utils.MiniDepsBuild(p, { 'cargo', 'build', '--release' }) end)
            end,
        },
        fzf = {
            post_install = function()
                MiniDeps.later(function() vim.fn['fzf#install']() end)
            end,
            post_checkout = function()
                MiniDeps.later(function() vim.fn['fzf#install']() end)
            end,
        },
    }
end

Utils.ReadFromFile = function(f)
    local path = vim.fn.stdpath('config') .. '/static/files/' .. f
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
    -- Formatting is handled by `stevearc/conform.nvim`
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    local set = vim.keymap.set

    set('n', 'E', '<Cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>', { desc = 'Eval', buffer = bufnr })
    set('n', 'K', '<Cmd>lua vim.lsp.buf.hover({ border = "rounded" })<CR>', { desc = 'Eval', buffer = bufnr })
    set('n', '<Leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'Actions', buffer = bufnr })
    set('n', '<Leader>ln', '<Cmd>lua vim.lsp.buf.rename()<CR>', { desc = 'Rename', buffer = bufnr })
end

local function swap_mark_case(key)
    if key:match('%u') then -- Uppercase
        return key:lower()
    elseif key:match('%l') then -- Lowercase
        return key:upper()
    else
        return key -- Return unchanged for non-alphabetic characters
    end
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
