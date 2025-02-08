_G.Utils = {}

Utils.Group = function(name, fn) fn(vim.api.nvim_create_augroup(name, { clear = true })) end

Utils.Build = function(params, cmd)
    local prefix = 'Building ' .. params.name
    vim.notify(prefix, 'INFO')

    local obj = vim.system(cmd, { cwd = params.path }):wait()
    local res = obj.code == 0 and (prefix .. ' done') or (prefix .. ' failed')
    local lvl = obj.code == 0 and 'INFO' or 'ERROR'

    vim.notify(res, lvl)
end
