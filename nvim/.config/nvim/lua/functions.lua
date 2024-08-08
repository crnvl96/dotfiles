local M = {}

function M.au(events, group, callback, opts)
    return vim.api.nvim_create_autocmd(
        events,
        vim.tbl_extend('error', { group = group, callback = callback }, opts or {})
    )
end

function M.g(name, clear)
    name = string.format('%s/%s', vim.g.whoami, name)
    return vim.api.nvim_create_augroup(name, { clear = clear })
end

function M.map()
    local function set(lhs, rhs, opts, mode)
        opts = type(opts) == 'string' and { desc = opts } or opts
        return vim.keymap.set(mode, lhs, rhs, opts)
    end

    local function nmap(lhs, rhs, opts) return set(lhs, rhs, opts, 'n') end
    local function vmap(lhs, rhs, opts) return set(lhs, rhs, opts, 'v') end
    local function xmap(lhs, rhs, opts) return set(lhs, rhs, opts, 'x') end
    local function imap(lhs, rhs, opts) return set(lhs, rhs, opts, 'i') end
    local function tmap(lhs, rhs, opts) return set(lhs, rhs, opts, 't') end
    local function lnmap(lhs, rhs, opts) return set('<leader>' .. lhs, rhs, opts, 'n') end
    local function lvmap(lhs, rhs, opts) return set('<leader>' .. lhs, rhs, opts, 'v') end

    return {
        n = nmap,
        v = vmap,
        x = xmap,
        i = imap,
        t = tmap,
        ln = lnmap,
        lv = lvmap,
    }
end

return M
