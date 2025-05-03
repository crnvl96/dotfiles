MiniDeps.now(function() MiniDeps.add({ name = 'mini.nvim' }) end)
MiniDeps.now(function() MiniDeps.add('nvim-lua/plenary.nvim') end)
MiniDeps.now(function() MiniDeps.add('neovim/nvim-lspconfig') end)
MiniDeps.now(function() require('mini.icons').setup() end)

MiniDeps.now(function()
    MiniDeps.add('nvim-treesitter/nvim-treesitter')
    require('nvim-treesitter.configs').setup({
        ensure_installed = {
            'c',
            'lua',
            'vim',
            'vimdoc',
            'query',
            'markdown',
            'markdown_inline',
            'javascript',
            'typescript',
            'tsx',
            'ruby',
            'python',
        },
        sync_install = false,
        ignore_install = {},
        indent = { enable = true },
        highlight = {
            enable = true,
            disable = function(_, buf)
                local max_filesize = 250 * 1024
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then return true end
            end,
            additional_vim_regex_highlighting = false,
        },
    })
end)

MiniDeps.later(function()
    MiniDeps.add('tpope/vim-dadbod')
    MiniDeps.add('kristijanhusak/vim-dadbod-ui')
    MiniDeps.add('tpope/vim-fugitive')
    MiniDeps.add('tpope/vim-rhubarb')
    MiniDeps.add('mbbill/undotree')
    MiniDeps.add('christoomey/vim-tmux-navigator')

    vim.keymap.set('n', '<C-h>', '<Cmd>TmuxNavigateLeft<CR>')
    vim.keymap.set('n', '<C-j>', '<Cmd>TmuxNavigateDown<CR>')
    vim.keymap.set('n', '<C-k>', '<Cmd>TmuxNavigateUp<CR>')
    vim.keymap.set('n', '<C-l>', '<Cmd>TmuxNavigateRight<CR>')
end)

MiniDeps.later(function()
    MiniDeps.add('mfussenegger/nvim-dap')
    MiniDeps.add('suketa/nvim-dap-ruby')

    require('dap-ruby').setup()

    vim.keymap.set('n', '<leader>db', require('dap').toggle_breakpoint)
    vim.keymap.set('n', '<leader>dc', require('dap').continue)
    vim.keymap.set('n', '<leader>dt', require('dap').terminate)
    vim.keymap.set('n', '<Leader>dr', require('dap').repl.toggle)
    vim.keymap.set({ 'n', 'v' }, '<Leader>dh', require('dap.ui.widgets').hover)
    vim.keymap.set('n', '<Leader>df', function()
        local widgets = require('dap.ui.widgets')
        local my_sidebar = widgets.sidebar(widgets.frames)
        my_sidebar.open()
    end)
    vim.keymap.set('n', '<Leader>ds', function()
        local widgets = require('dap.ui.widgets')
        local my_sidebar = widgets.sidebar(widgets.scopes)
        my_sidebar.open()
    end)
end)

MiniDeps.later(function()
    MiniDeps.add('ibhagwan/fzf-lua')
    require('fzf-lua').setup({
        fzf_opts = {
            ['--cycle'] = '',
        },
        winopts = {
            preview = {
                vertical = 'down:45%',
                horizontal = 'right:60%',
                layout = 'flex',
                flip_columns = 150,
            },
        },
        keymap = {
            fzf = {
                ['ctrl-q'] = 'select-all+accept',
                ['ctrl-r'] = 'toggle+down',
                ['ctrl-e'] = 'toggle+up',
                ['ctrl-a'] = 'select-all',
                ['ctrl-o'] = 'toggle-all',
                ['ctrl-u'] = 'half-page-up',
                ['ctrl-d'] = 'half-page-down',
                ['ctrl-x'] = 'jump',
                ['ctrl-f'] = 'preview-page-down',
                ['ctrl-b'] = 'preview-page-up',
            },
            builtin = {
                ['<c-f>'] = 'preview-page-down',
                ['<c-b>'] = 'preview-page-up',
            },
        },
    })
    vim.ui.select = function(items, opts, on_choice)
        if not require('fzf-lua.providers.ui_select').is_registered() then
            require('fzf-lua.providers.ui_select').register()
        end
        if #items > 0 then return vim.ui.select(items, opts, on_choice) end
    end
    vim.keymap.set('n', '<Leader>f', function() require('fzf-lua').files() end)
    vim.keymap.set('n', '<Leader>l', function() require('fzf-lua').blines() end)
    vim.keymap.set('n', '<Leader>g', function() require('fzf-lua').live_grep() end)
    vim.keymap.set('x', '<Leader>g', function() require('fzf-lua').grep_visual() end)
    vim.keymap.set('n', '<Leader>b', function() require('fzf-lua').buffers() end)
    vim.keymap.set('n', "<Leader>'", function() require('fzf-lua').resume() end)
    vim.keymap.set('n', '<Leader>x', function() require('fzf-lua').quickfix() end)
end)

MiniDeps.later(function()
    MiniDeps.add('stevearc/conform.nvim')
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    vim.g.conform = true
    require('conform').setup({
        notify_on_error = true,
        formatters = { injected = { ignore_errors = true } },
        formatters_by_ft = {
            ['_'] = { 'trim_whitespace', 'trim_newlines' },
            lua = { 'stylua' },
            json = { 'prettierd' },
            jsonc = { 'prettierd' },
            markdown = { 'prettierd', 'injected' },
            python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
            ruby = { 'rubocop' },
            eruby = { 'rubocop' },
            typescript = { 'prettierd' },
            -- javascript = { 'prettierd' },
            typescriptreact = { 'prettierd' },
        },
        format_on_save = function()
            if not vim.g.conform then return end
            return { timeout_ms = 3000, lsp_format = 'fallback' }
        end,
    })
end)

MiniDeps.later(function()
    local function map_split(buf_id, lhs, direction)
        local minifiles = require('mini.files')
        local function rhs()
            local window = minifiles.get_explorer_state().target_window
            if window == nil or minifiles.get_fs_entry().fs_type == 'directory' then return end
            local new_target_window
            vim.api.nvim_win_call(window, function()
                vim.cmd(direction .. ' split')
                new_target_window = vim.api.nvim_get_current_win()
            end)
            minifiles.set_target_window(new_target_window)
            minifiles.go_in({ close_on_file = true })
        end
        vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = 'Split ' .. string.sub(direction, 12) })
    end

    vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
            local buf_id = args.data.buf_id
            map_split(buf_id, '<C-w>s', 'belowright horizontal')
            map_split(buf_id, '<C-w>v', 'belowright vertical')
        end,
    })

    vim.keymap.set('n', '-', function()
        local bufname = vim.api.nvim_buf_get_name(0)
        local path = vim.fn.fnamemodify(bufname, ':p')
        if path and vim.uv.fs_stat(path) then require('mini.files').open(bufname, false) end
    end)

    require('mini.files').setup({
        mappings = {
            show_help = '?',
            go_in_plus = 'L',
            go_out_plus = 'H',
            go_in = '',
            go_out = '',
        },
    })
end)
