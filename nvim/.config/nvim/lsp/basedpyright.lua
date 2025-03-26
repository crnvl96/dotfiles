local lbin = vim.env.HOME .. '/.local/bin/'

vim.lsp.config.basedpyright = {
    cmd = { lbin .. 'basedpyright-langserver', '--stdio' },

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

    settings = {
        basedpyright = {
            disableOrganizeImports = true,
            analysis = { autoImportCompletions = true, diagnosticMode = 'openFilesOnly' },
        },
    },
}
