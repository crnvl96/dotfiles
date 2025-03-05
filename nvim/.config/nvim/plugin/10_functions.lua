local later = MiniDeps.later

_G.Utils = {}

Utils.Group = function(name, fn) fn(vim.api.nvim_create_augroup(name, { clear = true })) end

Utils.OnAttach = function(client, bufnr)
    -- Formatting is handled by `stevearc/conform.nvim`
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    local set = vim.keymap.set
    set('n', 'E', function() vim.diagnostic.open_float({ border = 'rounded' }) end, { desc = 'Eval', buffer = bufnr })
    set('n', 'K', function() vim.lsp.buf.hover({ border = 'rounded' }) end, { desc = 'Eval', buffer = bufnr })
    set('n', '<Leader>la', function() vim.lsp.buf.code_action() end, { desc = 'Actions', buffer = bufnr })
    set('n', '<Leader>ln', function() vim.lsp.buf.rename() end, { desc = 'Rename', buffer = bufnr })
    set('n', '<Leader>le', "<Cmd>Pick diagnostic scope='all'<CR>", { desc = 'Diagnostics', buffer = bufnr })
    set('n', '<Leader>ls', "<Cmd>Pick lsp scope='document_symbol'<CR>", { desc = 'Document Symbols', buffer = bufnr })
    set('n', '<Leader>lS', "<Cmd>Pick lsp scope='workspace_symbol'<CR>", { desc = 'Wksp Symbols', buffer = bufnr })
    set('n', '<Leader>ld', "<Cmd>Pick lsp scope='definition'<CR>", { desc = 'Definition', buffer = bufnr })
    set('n', '<Leader>lD', "<Cmd>Pick lsp scope='declaration'<CR>", { desc = 'Declaration', buffer = bufnr })
    set('n', '<Leader>li', "<Cmd>Pick lsp scope='implementation'<CR>", { desc = 'Impl', buffer = bufnr })
    set('n', '<Leader>ly', "<Cmd>Pick lsp scope='type_definition'<CR>", { desc = 'Typedefs', buffer = bufnr })
    set('n', '<Leader>lr', "<Cmd>Pick lsp scope='references'<CR>", { desc = 'References', buffer = bufnr })
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
                later(function() vim.cmd('TSUpdate') end)
            end,
            post_checkout = function()
                later(function() vim.cmd('TSUpdate') end)
            end,
        },
        blink = {
            post_install = function(p)
                later(function() Utils.MiniDepsBuild(p, { 'cargo', 'build', '--release' }) end)
            end,
            post_checkout = function(p)
                later(function() Utils.MiniDepsBuild(p, { 'cargo', 'build', '--release' }) end)
            end,
        },
    }
end

function _G.qftf(info)
    local items
    local ret = {}
    -- The name of item in list is based on the directory of quickfix window.
    -- Change the directory for quickfix window make the name of item shorter.
    -- It's a good opportunity to change current directory in quickfixtextfunc :)
    --
    -- local alterBufnr = vim.fn.bufname('#') -- alternative buffer is the buffer before enter qf window
    -- local root = getRootByAlterBufnr(alterBufnr)
    -- vim.cmd(('noa lcd %s'):format(vim.fn.fnameescape(root)))

    local fn = vim.fn

    if info.quickfix == 1 then
        items = fn.getqflist({ id = info.id, items = 0 }).items
    else
        items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
    end
    local limit = 62
    local fnameFmt1, fnameFmt2 = '%-' .. limit .. 's', '…%.' .. (limit - 1) .. 's'
    local validFmt = '%s │%5d:%-3d│%s %s'
    for i = info.start_idx, info.end_idx do
        local e = items[i]
        local fname = ''
        local str
        if e.valid == 1 then
            if e.bufnr > 0 then
                fname = fn.bufname(e.bufnr)
                if fname == '' then
                    fname = '[No Name]'
                else
                    fname = fname:gsub('^' .. vim.env.HOME, '~')
                end
                -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
                if #fname <= limit then
                    fname = fnameFmt1:format(fname)
                else
                    fname = fnameFmt2:format(fname:sub(1 - limit))
                end
            end
            local lnum = e.lnum > 99999 and -1 or e.lnum
            local col = e.col > 999 and -1 or e.col
            local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
            str = validFmt:format(fname, lnum, col, qtype, e.text)
        else
            str = e.text
        end
        table.insert(ret, str)
    end
    return ret
end
