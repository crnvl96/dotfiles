vim.lsp.config.biome = {
    cmd = {
        ASDFNode .. 'biome',
        'lsp-proxy',
    },
    filetypes = {
        'astro',
        'css',
        'graphql',
        'javascript',
        'javascriptreact',
        'json',
        'jsonc',
        'svelte',
        'typescript',
        'typescript.tsx',
        'typescriptreact',
        'vue',
    },
    root_dir = function(buffer, cb)
        local file_patterns = {
            'biome.json',
            'biome.jsonc',
        }
        if not buffer then return end
        local root = vim.fs.root(buffer, file_patterns)
        if root then cb(root) end
    end,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
}
