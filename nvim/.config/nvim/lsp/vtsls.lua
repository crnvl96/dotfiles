vim.lsp.config.vtsls = {
    cmd = { ASDFNode .. 'vtsls', '--stdio' },
    filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
    },
    root_dir = function(buffer, cb)
        local file_patterns = {
            'tsconfig.json',
            'package.json',
            'jsconfig.json',
            '.git',
        }
        if not buffer then return end
        local root = vim.fs.root(buffer, file_patterns)
        if root then cb(root) end
    end,
}
