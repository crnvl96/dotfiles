local function insert_package_json(config_files, field, fname)
    local path = vim.fn.fnamemodify(fname, ':h')
    local root_with_package = vim.fs.dirname(vim.fs.find('package.json', { path = path, upward = true })[1])

    if root_with_package then
        -- only add package.json if it contains field parameter
        for line in io.lines(root_with_package .. '/package.json') do
            if line:find(field) then
                config_files[#config_files + 1] = 'package.json'
                break
            end
        end
    end
    return config_files
end

vim.lsp.config.eslint = {
    cmd = { ASDFNode .. 'vscode-eslint-language-server', '--stdio' },
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

        local fname = vim.api.nvim_buf_get_name(buffer)
        if not fname or fname == '' then return end

        insert_package_json(file_patterns, 'eslintConfig', fname)

        local root = vim.fs.root(buffer, file_patterns)

        if root then cb(root) end
    end,
    on_init = function(client) client.server_capabilities.completionProvider = false end,
    settings = function(init_options)
        return {
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
            workingDirectories = { init_options.rootPath },
            run = 'onType',
            problems = { shortenToSingleLine = false },
            nodePath = '',
            codeAction = {
                disableRuleComment = {
                    enable = true,
                    location = 'separateLine',
                },
                showDocumentation = {
                    enable = true,
                },
            },
        }
    end,
}
