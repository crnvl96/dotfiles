require('nvim_aider').setup({
    args = {
        '--model',
        'deepseek/deepseek-chat',
        '--no-auto-commits',
        '--pretty',
        '--stream',
    },
    picker_cfg = { preset = 'vscode' },
    win = { position = 'right' },
})
