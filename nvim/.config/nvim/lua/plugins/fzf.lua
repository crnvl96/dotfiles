local add = MiniDeps.add

local function l_nmap(lhs, rhs, desc)
    local set = vim.keymap.set
    set('n', '<leader>' .. lhs, rhs, { desc = desc })
end

local function l_vmap(lhs, rhs, desc)
    local set = vim.keymap.set
    set('v', '<leader>' .. lhs, rhs, { desc = desc })
end

return function()
    add('ibhagwan/fzf-lua')

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

    l_nmap('fb', fzf.buffers, 'Buffers')
    l_nmap('ff', fzf.files, 'Files')
    l_nmap('fo', fzf.oldfiles, 'Oldfiles')
    l_nmap('fq', fzf.quickfix, 'Qf')
    l_nmap('fl', fzf.blines, 'Lines')
    l_nmap('ft', fzf.tabs, 'Tabs')
    l_nmap('sg', fzf.live_grep, 'Lgrep')
    l_nmap('sG', fzf.live_grep_resume, 'Lgrep resume')
    l_nmap('sq', fzf.lgrep_quickfix, 'Lgrep qf')
    l_nmap('sl', fzf.lgrep_curbuf, 'Lgrep lines')
    l_vmap('sg', fzf.grep_visual, 'Lgrep visual')
end
