-- local asdf = vim.env.HOME .. '/.asdf/shims/'
local asdf = vim.env.HOME .. '/.asdf/installs/nodejs/22.14.0/bin/'

vim.lsp.config.eslint = {
    cmd = {
        asdf .. 'vscode-eslint-language-server',
        '--stdio',
    },

    filetypes = { 'typescript' },

    root_dir = function(buffer, cb)
        local file_patterns = {
            '.eslintrc.js',
            'eslint.config.mjs',
        }

        if buffer then
            local root = vim.fs.root(buffer, file_patterns)
            if root then cb(root) end
        end
    end,

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
