local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
    vim.lsp.enable({
        -- 'efm',
        'eslint',
        'vtsls',
        'ruff',
        'basedpyright',
        'lua_ls',
        'ruby_lsp',
    })
end)

now(function() add({ name = 'mini.nvim' }) end)
now(function() add('nvim-lua/plenary.nvim') end)
now(function() add('neovim/nvim-lspconfig') end)

later(function() add('mbbill/undotree') end)

later(function()
    add('tpope/vim-fugitive')
    add('tpope/vim-rhubarb')
    add('tpope/vim-sleuth')
end)

later(function()
    add('lervag/vimtex')
    vim.g.vimtex_view_method = 'zathura'
end)

now(function()
    add('mfussenegger/nvim-dap')
    add('nvim-neotest/nvim-nio')
    add('rcarriga/nvim-dap-ui')

    -- RUBY_DEBUG_HOST=127.0.0.1 RUBY_DEBUG_PORT=38698 rdbg -O -c -- bin/rails server
    add('suketa/nvim-dap-ruby')

    local dap, du, dr = require('dap'), require('dapui'), require('dap-ruby')
    local b = dap.listeners.before

    du.setup()
    dr.setup()

    b.attach.dapui_config = du.open
    b.launch.dapui_config = du.open
    b.event_terminated.dapui_config = du.close
    b.event_exited.dapui_config = du.close

    local set = vim.keymap.set

    set({ 'n', 'v' }, '<leader>de', du.eval)
    set('n', '<leader>du', du.toggle)

    set('n', '<leader>db', dap.toggle_breakpoint)
    set('n', '<leader>dc', dap.continue)
    set('n', '<leader>dt', dap.terminate)
end)

later(function()
    add('nvim-treesitter/nvim-treesitter')

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

later(function()
    add('ibhagwan/fzf-lua')

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

later(function()
    add('stevearc/conform.nvim')

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
            eruby = { 'erb_format' },
            typescript = { 'prettierd' },
            typescriptreact = { 'prettierd' },
        },
        format_on_save = function()
            if not vim.g.conform then return end
            return { timeout_ms = 3000, lsp_format = 'fallback' }
        end,
    })
end)
