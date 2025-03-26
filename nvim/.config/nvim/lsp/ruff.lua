local lbin = vim.env.HOME .. '/.local/bin/'

vim.lsp.config.ruff = {
    cmd = { lbin .. 'ruff', 'server' },

    filetypes = { 'python' },

    root_dir = function(buffer, cb)
        local file_patterns = {
            'pyproject.toml',
        }

        if buffer then
            local root = vim.fs.root(buffer, file_patterns)
            if root then return cb(root) end
        end
    end,

    on_init = function(client) client.server_capabilities.hoverProvider = false end,

    init_options = {
        settings = {
            lineLength = 88,
            logLevel = 'debug',
        },
    },
}
