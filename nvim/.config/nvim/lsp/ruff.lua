vim.lsp.config.ruff = {
    cmd = { LBin .. 'ruff', 'server' },
    filetypes = { 'python' },
    root_markers = {
        'pyproject.toml',
        'ruff.toml',
        '.ruff.toml',
    },
    on_init = function(client) client.server_capabilities.hoverProvider = false end,
    init_options = {
        settings = {
            lineLength = 88,
            logLevel = 'debug',
        },
    },
}
