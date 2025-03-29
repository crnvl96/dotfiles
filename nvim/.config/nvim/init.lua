local mini_path = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'

if not vim.loop.fs_stat(mini_path) then
    local clone_cmd = {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/echasnovski/mini.nvim',
        mini_path,
    }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup()

MiniDeps.add({ name = 'mini.nvim' })

-- vim.lsp.config('*', {
--     capabilities = vim.lsp.protocol.make_client_capabilities(),
-- })

-- if client:supports_method('textDocument/completion') then
--     client.server_capabilities.completionProvider.triggerCharacters = vim.split('qwertyuiopasdfghjklzxcvbnm. ', '')
--     vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
-- end

vim.lsp.enable({
    'basedpyright',
    'biome',
    'eslint',
    'harper_ls',
    'lua_ls',
    'ruff',
    'vtsls',
})
