vim.lsp.config.eslint = {
    cmd = {
        ASDFNode .. 'vscode-eslint-language-server',
        '--stdio',
    },
    filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
        'vue',
        'svelte',
        'astro',
    },
    root_dir = function(buffer, cb)
        local file_patterns = {
            '.eslintrc',
            '.eslintrc.js',
            '.eslintrc.cjs',
            '.eslintrc.yaml',
            '.eslintrc.yml',
            '.eslintrc.json',
            'eslint.config.js',
            'eslint.config.mjs',
            'eslint.config.cjs',
            'eslint.config.ts',
            'eslint.config.mts',
            'eslint.config.cts',
        }
        if not buffer then return end
        local root = vim.fs.root(buffer, file_patterns)
        if root then cb(root) end
    end,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    on_init = function(client) client.server_capabilities.completionProvider = false end,
    settings = {
        validate = 'on',
        packageManager = nil,
        useESLintClass = false,
        experimental = {
            useFlatConfig = false,
        },
        codeActionOnSave = {
            enable = false,
            mode = 'all',
        },
        format = false,
        quiet = false,
        onIgnoredFiles = 'off',
        rulesCustomizations = {},
        run = 'onType',
        problems = { shortenToSingleLine = false },
        nodePath = '',
        workingDirectories = { mode = 'auto' },
        codeAction = {
            disableRuleComment = {
                enable = true,
                location = 'separateLine',
            },
            showDocumentation = {
                enable = true,
            },
        },
    },
}
