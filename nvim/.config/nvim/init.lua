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

NodePath = '/home/crnvl96/.asdf/installs/nodejs/22.14.0'
Methods = vim.lsp.protocol.Methods
RegisterCapability = vim.lsp.handlers[Methods.client_registerCapability]
LBin = vim.env.HOME .. '/.local/bin/'
ASDFNode = vim.env.HOME .. '/.asdf/installs/nodejs/22.14.0/bin/'
ASDFRust = vim.env.HOME .. '/.asdf/installs/rust/1.84.1/bin/'
ASDFGo = vim.env.HOME .. '/.asdf/installs/golang/1.23.5/bin/'
Brew = '/home/linuxbrew/.linuxbrew/bin/'

Adapter = 'gemini' -- huggingface, anthropic, gemini, deepseek

vim.env.PATH = NodePath .. '/bin:' .. vim.env.PATH

vim.lsp.enable({
    'basedpyright',
    'biome',
    'eslint',
    'harper_ls',
    'lua_ls',
    'ruff',
    'vtsls',
})
