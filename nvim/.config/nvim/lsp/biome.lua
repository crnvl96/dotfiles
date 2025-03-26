-- local asdf = vim.env.HOME .. '/.asdf/shims/'
local asdf = vim.env.HOME .. '/.asdf/installs/nodejs/22.14.0/bin/'

vim.lsp.config.biome = {
    cmd = { asdf .. 'biome', 'lsp-proxy' },

    filetypes = { 'typescript' },

    root_dir = function(buffer, cb)
        local file_patterns = {
            'biome.json',
            'biome.jsonc',
        }

        if buffer then
            local root = vim.fs.root(buffer, file_patterns)
            if root then cb(root) end
        end
    end,
}
