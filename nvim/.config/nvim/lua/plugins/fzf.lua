return function()
    local f = require('functions')
    local map = f.map()

    MiniDeps.add({
        source = 'ibhagwan/fzf-lua',
        depends = {
            { source = 'echasnovski/mini.icons' },
        },
    })

    local fzf = require('fzf-lua')

    fzf.setup({
        fzf_opts = { ['--cycle'] = '' },
        winopts = {
            height = 0.85,
            width = 0.80,
            row = 0.50,
            col = 0.50,
            border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
            backdrop = 60,
            preview = { hidden = 'hidden' },
        },
        keymap = {
            fzf = {
                true,
                ['alt-u'] = 'unix-line-discard',
                ['ctrl-d'] = 'half-page-down',
                ['ctrl-u'] = 'half-page-up',
                ['ctrl-f'] = 'preview-page-down',
                ['ctrl-b'] = 'preview-page-up',
            },
            builtin = {
                true,
                ['<C-f>'] = 'preview-page-down',
                ['<C-b>'] = 'preview-page-up',
            },
        },
    })

    vim.ui.select = fzf.register_ui_select

    map.ln('fb', fzf.buffers, 'Buffers')
    map.ln('ff', fzf.files, 'Files')
    map.ln('fo', fzf.oldfiles, 'Oldfiles')
    map.ln('fq', fzf.quickfix, 'Qf')
    map.ln('fl', fzf.blines, 'Lines')
    map.ln('ft', fzf.tabs, 'Tabs')
    map.ln('sg', fzf.live_grep, 'Lgrep')
    map.ln('sG', fzf.live_grep_resume, 'Lgrep resume')
    map.ln('sq', fzf.lgrep_quickfix, 'Lgrep qf')
    map.ln('sl', fzf.lgrep_curbuf, 'Lgrep lines')
    map.lv('sg', fzf.grep_visual, 'Lgrep visual')
end
