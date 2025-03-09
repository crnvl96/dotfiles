_G.Utils = {}

Utils.Group = function(name, fn) fn(vim.api.nvim_create_augroup(name, { clear = true })) end

Utils.ExpandCallable = function(x, ...)
    if vim.is_callable(x) then return x(...) end
    return x
end

Utils.SetBufLines = function(buf_id, lines) pcall(vim.api.nvim_buf_set_lines, buf_id, 0, -1, false, lines) end

Utils.OnAttach = function(client, bufnr)
    -- Formatting is handled by `stevearc/conform.nvim`
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    local set = vim.keymap.set
    set('n', 'E', '<Cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>', { desc = 'Eval', buffer = bufnr })
    set('n', 'K', '<Cmd>lua vim.lsp.buf.hover({ border = "rounded" })<CR>', { desc = 'Eval', buffer = bufnr })
    set('n', '<Leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'Actions', buffer = bufnr })
    set('n', '<Leader>ln', '<Cmd>lua vim.lsp.buf.rename()<CR>', { desc = 'Rename', buffer = bufnr })
    set('n', '<Leader>le', '<Cmd>lua vim.diagnostic.setqflist()<CR>', { desc = 'Diagnostics', buffer = bufnr })
    set('n', '<Leader>ls', '<Cmd>lua vim.lsp.buf.document_symbol()<CR>', { desc = 'Document Symbols', buffer = bufnr })
    set('n', '<Leader>lS', '<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>', { desc = 'WSymbols', buffer = bufnr })
    set('n', '<Leader>ld', '<Cmd>lua vim.lsp.buf.definition()<CR>', { desc = 'Definition', buffer = bufnr })
    set('n', '<Leader>lD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', { desc = 'Declaration', buffer = bufnr })
    set('n', '<Leader>li', '<Cmd>lua vim.lsp.buf.implementation()<CR>', { desc = 'Impl', buffer = bufnr })
    set('n', '<Leader>ly', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', { desc = 'Typedefs', buffer = bufnr })
    set('n', '<Leader>lr', '<Cmd>lua vim.lsp.buf.references()<CR>', { desc = 'References', buffer = bufnr })
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

function _G.qftf(info)
    local fn = vim.fn
    local results = {}
    local max_filename_length = 62

    -- Set working directory to project root
    local alt_buf = fn.bufnr('#')
    local root = fn.getcwd(alt_buf)
    vim.cmd(('noa lcd %s'):format(fn.fnameescape(root)))

    -- Get quickfix or location list items
    local items = info.quickfix == 1 and fn.getqflist({ id = info.id, items = 0 }).items
        or fn.getloclist(info.winid, { id = info.id, items = 0 }).items

    -- Format strings
    local full_fmt = '%-' .. max_filename_length .. 's'
    local truncated_fmt = '…%.' .. (max_filename_length - 1) .. 's'
    local line_fmt = '%s │%5d:%-3d│%s %s'

    for i = info.start_idx, info.end_idx do
        local entry = items[i]
        local formatted_line

        if entry.valid == 1 then
            -- Format filename
            local filename = ''
            if entry.bufnr > 0 then
                filename = fn.bufname(entry.bufnr)
                filename = filename == '' and '[No Name]' or filename:gsub('^' .. vim.env.HOME, '~')
                filename = #filename <= max_filename_length and full_fmt:format(filename)
                    or truncated_fmt:format(filename:sub(1 - max_filename_length))
            end

            -- Format line numbers and type
            local line_num = entry.lnum > 99999 and -1 or entry.lnum
            local col_num = entry.col > 999 and -1 or entry.col
            local entry_type = entry.type == '' and '' or ' ' .. entry.type:sub(1, 1):upper()

            formatted_line = line_fmt:format(filename, line_num, col_num, entry_type, entry.text)
        else
            formatted_line = entry.text
        end

        results[#results + 1] = formatted_line
    end

    return results
end
