-- local asdf = vim.env.HOME .. '/.asdf/shims/'
local asdf = vim.env.HOME .. '/.asdf/installs/nodejs/22.14.0/bin/'

vim.lsp.config.vtsls = {
    cmd = { asdf .. 'vtsls', '--stdio' },

    filetypes = { 'typescript', 'javascript' },

    root_dir = function(buffer, cb)
        local file_patterns = {
            'package.json',
        }

        if buffer then
            local root = vim.fs.root(buffer, file_patterns)
            if root then return cb(root) end
        end
    end,
}
