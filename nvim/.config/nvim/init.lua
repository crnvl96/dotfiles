-- Setup package manager
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

MiniDeps.add({ name = 'mini.nvim' }) -- Make the package manager be handled by itself

-- Path
local default_nodejs = vim.env.HOME .. '/.asdf/installs/nodejs/22.14.0/bin/'
vim.g.node_host_prog = default_nodejs .. 'node' -- Default node version used by nvim
vim.env.PATH = default_nodejs .. ':' .. vim.env.PATH -- Update neovim path

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--------------------------- Plugin development ----------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------

-- nvim-lspconfig
--- Important: Revert this when https://github.com/neovim/nvim-lspconfig/pull/3731  got merged
vim.cmd('set rtp+=/home/crnvl96/Developer/personal/nvim-lspconfig/')

---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------- End ------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------

--- Colorscheme
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end
vim.cmd.colorscheme('ham')

--- Options

vim.cmd('filetype plugin indent on')
vim.cmd('packadd cfilter')

vim.g.mapleader = ' ' -- <Space>  as leader key
vim.g.maplocalleader = ',' -- comma as local leader key
vim.o.breakindent = true -- Wrapped lines will continue visually indented
vim.o.cursorline = false -- No cursorline
vim.o.winborder = 'single' -- Default border style of the floating windows
vim.o.diffopt = 'filler,internal,closeoff,algorithm:histogram,context:5,linematch:60' -- File diff opts
vim.o.conceallevel = 0 -- Adjust conceal
vim.o.expandtab = true -- Convert tabs into spaces
vim.o.grepprg = 'rg --vimgrep --smart-case' -- Integration with ripgrep
vim.o.ignorecase = true -- Ignore case in search patterns
vim.o.infercase = true -- Smart case handling when searching patterns
vim.o.laststatus = 0 -- No statusbar
vim.o.linebreak = true -- Avoid breaking words in the middle when line is break
vim.o.mouse = 'a' -- Enable mouse in all modes
vim.o.number = true -- Enable line numbers
vim.o.relativenumber = true -- Enable relative line numbers
vim.o.ruler = false -- Don't show cursor position on statusline
vim.o.scrolloff = 8 -- Always keep a vertical gap between cursor and the edges of the screen
vim.o.sidescrolloff = 8 -- Always keep a horizontal gap between cursor and the edges of the screen
vim.o.shiftwidth = 4 -- Number of spaces to use for each step of indent
vim.o.showcmd = false -- Don't show the command being tapped on the statusline
vim.o.showmode = false -- Don't show current mode on the statusline
vim.o.signcolumn = 'yes' -- Let nvim handle the signcolumn
vim.o.smartcase = true -- Don't consider 'ignorecase' if the pattern has uppercase letters
vim.o.softtabstop = 4 -- Number of spaces that a <TAB> counts for
vim.o.splitkeep = 'screen' -- Avoid vertical movement when splitting screens
vim.o.splitright = true -- Split screens to the right
vim.o.splitbelow = true -- Split screens to below
vim.o.swapfile = false -- Disable swapfile
vim.o.tabstop = 4 -- Number of spaces that a <Tab> counts for
vim.o.undofile = true -- Enable persistent undo
vim.o.virtualedit = 'block' -- Block selection on visual mode
vim.o.wildignorecase = true -- Case is ignored when completing file names and directories
vim.o.clipboard = 'unnamed' -- Make \" the default register
vim.o.wrap = false -- Disable linewrap
vim.o.writebackup = false -- Don't make a backup when overwriting a file
vim.o.list = true -- Show special symbols (Such as tabs, trailing spaces, etc...)
vim.o.listchars = 'extends:…,nbsp:␣,precedes:…,tab:  ' -- The special symbols that need to be shown

-- Restore cursor position when enteting a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
    group = vim.api.nvim_create_augroup('crnvl96-restore-cursor', {}),
    callback = function(e)
        pcall(vim.api.nvim_win_set_cursor, vim.fn.bufwinid(e.buf), vim.api.nvim_buf_get_mark(e.buf, [["]]))
    end,
})

-- Prevent lsp to attach to invalid buffers
--
-- https://github.com/neovim/neovim/issues/33061
-- https://www.reddit.com/r/neovim/comments/1jpiz7w/nvim_011_with_native_lsp_doubles_intelephense_ls/
-- see https://github.com/neovim/nvim-lspconfig/blob/ff6471d4f837354d8257dfa326b031dd8858b16e/lua/lspconfig/util.lua#L23-L28
local function bufname_valid(bufname)
    if
        bufname:match('^/')
        or bufname:match('^[a-zA-Z]:')
        or bufname:match('^zipfile://')
        or bufname:match('^tarfile:')
    then
        return true
    end

    return false
end

-- LSP Attach
vim.o.foldlevel = 99 -- All folds under this value will be closed
vim.o.foldlevelstart = 99 -- Useful to always start editing with all folds closed
vim.o.foldmethod = 'expr' -- 'foldexpr' gives the fold level of a line.

local function on_attach(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false -- Formatting is handled by conform.nvim
    client.server_capabilities.documentRangeFormattingProvider = false -- Range formatting is handled by conform.nvim

    local set = function(lhs, rhs, opts, mode)
        opts = vim.tbl_extend('error', opts or {}, { buffer = bufnr })
        mode = mode or 'n'
        return vim.keymap.set(mode, lhs, rhs, opts)
    end

    set('E', vim.diagnostic.open_float)
    set('K', vim.lsp.buf.hover)
    set('ga', vim.lsp.buf.code_action)
    set('gn', vim.lsp.buf.rename)
    set('gd', vim.lsp.buf.definition)
    set('gD', vim.lsp.buf.declaration)
    set('gr', vim.lsp.buf.references, { nowait = true })
    set('gi', vim.lsp.buf.implementation)
    set('gy', vim.lsp.buf.type_definition)
    set('ge', vim.diagnostic.setqflist)
    set('gs', vim.lsp.buf.document_symbol)
    set('gS', vim.lsp.buf.workspace_symbol)

    if client:supports_method('textDocument/foldingRange') then
        vim.wo[vim.api.nvim_get_current_win()][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    else
        vim.wo[vim.api.nvim_get_current_win()][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end
end

-- Handle dynamic capabilities of lsp servers
local signature = vim.lsp.protocol.Methods.client_registerCapability
local register_capability = vim.lsp.handlers[signature] -- Store the method's original signature here

vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then return end
    on_attach(client, vim.api.nvim_get_current_buf()) -- Call the default `on_attach` function
    return register_capability(err, res, ctx) -- Call the original method's signature
end

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('crnvl96-on-lsp-attach', {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end
        local bufname = vim.api.nvim_buf_get_name(args.buf)
        -- Stop the LSP client on invalid buffers
        -- see https://github.com/neovim/nvim-lspconfig/blob/ff6471d4f837354d8257dfa326b031dd8858b16e/lua/lspconfig/configs.lua#L97-L99
        if #bufname ~= 0 and not bufname_valid(bufname) then
            client.stop()
            return
        end
        on_attach(client, args.buf) -- Call the default `on_attach` function
    end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('crnvl96-sticky-yank', {}),
    callback = function()
        (vim.hl or vim.highlight).on_yank()
        if vim.v.event.operator == 'y' and vim.b.cursorPreYank then
            vim.api.nvim_win_set_cursor(0, vim.b.cursorPreYank)
            vim.b.cursor_pre_yank = nil
        end
    end,
})

local function custom_y(cmd)
    return function()
        vim.b.cursorPreYank = vim.api.nvim_win_get_cursor(0)
        return cmd
    end
end

vim.keymap.set({ 'n', 'x' }, 'y', custom_y('y'), { expr = true })
vim.keymap.set('n', 'Y', custom_y('yg_'), { expr = true })
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>y', custom_y('"+y'), { expr = true })
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>Y', custom_y('"+yg_'), { expr = true })
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>p', '"+p')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>P', '"+P')
vim.keymap.set('x', 'p', 'P')
vim.keymap.set('n', 'gY', ":<C-U>let @+ = expand('%:.')<CR>")
vim.keymap.set('n', 'gP', '`[v`]')
vim.keymap.set({ 'n', 'x', 'i', 's' }, '<Esc>', '<Cmd>noh<CR><Esc>')
vim.keymap.set({ 'n', 'x', 'i', 's' }, '<C-x>', '<Cmd>noh<CR><Esc>')
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set('n', '<C-Down>', '<Cmd>resize -5<CR>')
vim.keymap.set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
vim.keymap.set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')
vim.keymap.set('n', '<C-Up>', '<Cmd>resize +5<CR>')
vim.keymap.set('n', '<C-w>+', '<Cmd>resize +5<CR>')
vim.keymap.set('n', '<C-w>-', '<Cmd>resize -5<CR>')
vim.keymap.set('n', '<C-w><', '<Cmd>vertical resize -20<CR>')
vim.keymap.set('n', '<C-w>>', '<Cmd>vertical resize +20<CR>')
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')

---
--- Plugins
---

-- Builder used during plugins installation/updates
local build = function(p, cmd)
    vim.notify('Building ' .. p.name, vim.log.levels.INFO)
    local obj = vim.system(cmd, { cwd = p.path }):wait()
    if obj.code == 0 then
        vim.notify('Finished building ' .. p.name, vim.log.levels.INFO)
    else
        vim.notify('Failed building' .. p.name, vim.log.levels.ERROR)
    end
end

MiniDeps.add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = {
        post_install = function()
            MiniDeps.later(function() vim.cmd('TSUpdate') end)
        end,
        post_checkout = function()
            MiniDeps.later(function() vim.cmd('TSUpdate') end)
        end,
    },
})

MiniDeps.add('nvim-lua/plenary.nvim')
MiniDeps.add('tpope/vim-fugitive')
MiniDeps.add('tpope/vim-rhubarb')
MiniDeps.add('tpope/vim-sleuth')
MiniDeps.add('mbbill/undotree')
MiniDeps.add('ibhagwan/fzf-lua')
MiniDeps.add('stevearc/conform.nvim')
MiniDeps.add('lervag/vimtex')
MiniDeps.add('stevearc/oil.nvim')

MiniDeps.add({
    source = 'Saghen/blink.cmp',
    hooks = {
        post_install = function(p)
            MiniDeps.later(function() build(p, { 'cargo', 'build', '--release' }) end)
        end,
        post_checkout = function(p)
            MiniDeps.later(function() build(p, { 'cargo', 'build', '--release' }) end)
        end,
    },
})

MiniDeps.add('olimorris/codecompanion.nvim')
MiniDeps.add('obsidian-nvim/obsidian.nvim')

--- VimTex

vim.g.vimtex_view_method = 'zathura'

--- Treesitter

local treesitter = require('nvim-treesitter.configs')
treesitter.setup({
    highlight = { enable = true },
    auto_install = false,
    ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline' },
})

--- LSP servers are enabled here

local function root_dir(bufnr, on_dir, pat)
    if not bufnr then return end
    local root = vim.fs.root(bufnr, pat)
    if root then on_dir(root) end
end

vim.lsp.enable({ 'biome', 'eslint', 'vtsls', 'ruff', 'basedpyright', 'lua_ls', 'ruby_lsp' })

vim.lsp.config('biome', {
    cmd = { default_nodejs .. 'biome', 'lsp-proxy' },
    root_dir = function(bufnr, on_dir) root_dir(bufnr, on_dir, { 'biome.json', 'biome.jsonc' }) end,
})

vim.lsp.config('eslint', {
    cmd = { default_nodejs .. 'vscode-eslint-language-server', '--stdio' },
    on_attach = function(_, bufnr)
        vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            group = vim.api.nvim_create_augroup('crnvl96-eslint-fix-all', {}),
            command = 'EslintFixAll',
        })
    end,
})
vim.lsp.config('vtsls', { cmd = { default_nodejs .. 'vtsls', '--stdio' } })

vim.lsp.config('ruff', {
    on_init = function(client) client.server_capabilities.hoverProvider = false end,
    init_options = { settings = { lineLength = 88, logLevel = 'debug' } },
})

vim.lsp.config('lua_ls', {
    on_init = function(client)
        client.server_capabilities.semanticTokensProvider = nil
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath('config')
                and (vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc'))
            then
                return
            end
        end
        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = { version = 'LuaJIT' },
            workspace = {
                checkThirdParty = false,
                library = { '$VIMRUNTIME', '$XDG_DATA_HOME/nvim/site/pack/deps/opt', '${3rd}/luv/library' },
            },
        })
    end,
    settings = {
        Lua = {},
    },
})

--- File explorer
---

--  A simple script to copying files over ssh connections is:
--
--  ```sh
--  #!/bin/bash
--  HOST=$1
--  PORT=$2
--  PATH=$3
--  scp -P ${PORT} *.py root@${HOST}:${PATH}
--  scp -P ${PORT} requirements.txt root@${HOST}:${PATH}
--  ```
--
--  So, for example, given the connection `ssh root@194.26.196.142 -p 12826` and the project path being `/app/myproject`
--  194.26.196.142 is the HOST
--  12826 is the PORT
--  /app/myproject is the PATH
--
--  So, you would run ./script.sh 194.26.196.142 12826 /app/myproject
--
--  After that, you could connect with the ssh by running:
--  ssh -L 4004:localhost:6006 root@194.26.196.142 -p 12826 (where 4404 is your local port, and 6606 is the remote machine port)
--
--  A ssh config entry would look like this:
--
--  Host runpod
--    Hostname 194.26.196.142
--    User root
--    Port 12826
--    LocalForward 4004 localhost:6006
--    ServerAliveInterval 180
--    ServerAliveCountMax 4
--
--  Or, you could run just like this: `nvim oil-ssh://root@194.26.196.142:12826/app/myproject`

require('oil').setup()
vim.keymap.set('n', '-', '<Cmd>Oil<CR>')

--- Code completion (blink.cmp)

require('blink.cmp').setup({
    cmdline = {
        keymap = {
            ['<Tab>'] = {
                function(cmp)
                    if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() then return cmp.accept() end
                end,
                'show_and_insert',
                'select_next',
            },
            ['<S-Tab>'] = { 'show_and_insert', 'select_prev' },
            ['<C-space>'] = { 'show', 'fallback' },
            ['<C-n>'] = {
                function(cmp)
                    if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() then return cmp.accept() end
                end,
                'show_and_insert',
                'select_next',
            },
            ['<C-p>'] = {
                function(cmp)
                    if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() then return cmp.accept() end
                end,
                'show_and_insert',
                'select_next',
            },
            ['<Right>'] = { 'select_next', 'fallback' },
            ['<Left>'] = { 'select_prev', 'fallback' },
            ['<C-y>'] = { 'select_and_accept' },
            ['<C-e>'] = { 'cancel' },
        },
    },
})

vim.opt.completeopt:append('fuzzy,noselect')
vim.opt.wildoptions:append('fuzzy')

---
--- Conform.nvim: code formatter
---

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.g.conform = true

local conform = require('conform')
conform.setup({
    notify_on_error = true,
    formatters = {
        injected = { ignore_errors = true },
        prettierd = { command = default_nodejs .. 'prettierd' },
        biome = { command = default_nodejs .. 'biome' },
    },
    formatters_by_ft = {
        ['_'] = { 'trim_whitespace', 'trim_newlines' },
        lua = { 'stylua' },
        css = { 'prettierd' },
        html = { 'prettierd' },
        scss = { 'prettierd' },
        json = { 'prettierd' },
        jsonc = { 'prettierd' },
        yaml = { 'yamlfmt' },
        yml = { 'yamlfmt' },
        toml = { 'taplo' },
        markdown = { 'prettierd', 'injected' },
        python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
        ruby = { 'rubocop' },
        typescript = function(bufnr)
            if bufnr and vim.fs.root(bufnr, { 'biome.json', 'biome.jsonc' }) then
                return { 'biome', 'biome-check', 'biome-organize-imports' }
            else
                return { 'prettierd' }
            end
        end,
        javascript = function(bufnr)
            if bufnr and vim.fs.root(bufnr, { 'biome.json', 'biome.jsonc' }) then
                return { 'biome', 'biome-check', 'biome-organize-imports' }
            else
                return { 'prettierd' }
            end
        end,
    },
    format_on_save = function()
        if not vim.g.conform then return end
        return { timeout_ms = 3000, lsp_format = 'fallback' }
    end,
})

vim.api.nvim_create_user_command('Format', function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ['end'] = { args.line2, end_line:len() },
        }
    end
    require('conform').format({ async = true, lsp_format = 'fallback', range = range })
end, { range = true })

---
--- Fuzzy finder based on FZF
---

local fzf_lua = require('fzf-lua')
local fzf_lua_ui = require('fzf-lua.providers.ui_select')

fzf_lua.setup({
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
    if not fzf_lua_ui.is_registered() then fzf_lua_ui.register() end
    -- Don't trigger the ui select picker if there aren't items to be shown
    if #items > 0 then return vim.ui.select(items, opts, on_choice) end
end

vim.keymap.set('n', '<Leader>f', function() require('fzf-lua').files() end)
vim.keymap.set('n', '<Leader>l', function() require('fzf-lua').blines() end)
vim.keymap.set('n', '<Leader>g', function() require('fzf-lua').live_grep() end)
vim.keymap.set('x', '<Leader>g', function() require('fzf-lua').grep_visual() end)
vim.keymap.set('n', '<Leader>b', function() require('fzf-lua').buffers() end)
vim.keymap.set('n', "<Leader>'", function() require('fzf-lua').resume() end)
vim.keymap.set('n', '<Leader>x', function() require('fzf-lua').quickfix() end)

--- Codecompanion: LLMs integration within Neovim

-- Read information from local files to avoid exposing them in shell environment
local read_from_file = function(f)
    local vimstdconf = vim.fn.stdpath('config') -- default nvim config path
    local path = vimstdconf .. '/' .. f
    local file = io.open(path, 'r')
    if not file then return nil end
    local key = file:read('*a'):gsub('%s+$', '')
    file:close()
    if not key then
        vim.notify('Missing file: ' .. f, 'ERROR')
        return nil
    end
    return key
end

local adapters = require('codecompanion.adapters')

local setup_adapter = function(adapter, model)
    local key_path = '.' .. adapter
    local api_key = read_from_file(key_path)
    return adapters.extend(adapter, {
        env = { api_key = api_key },
        schema = { model = { default = model } },
    })
end

local codecompanion = require('codecompanion')
local llm_adapter = 'gemini'

codecompanion.setup({
    strategies = {
        chat = {
            adapter = llm_adapter,
            slash_commands = {
                file = { opts = { provider = 'fzf_lua' } },
                buffer = { opts = { provider = 'fzf_lua' } },
                help = { opts = { provider = 'fzf_lua' } },
                symbols = { opts = { provider = 'fzf_lua' } },
            },
        },
    },
    adapters = {
        anthropic = setup_adapter('anthropic', 'claude-3-7-sonnet-20250219'),
        gemini = setup_adapter('gemini', 'gemini-2.5-pro-preview-03-25'),
        deepseek = setup_adapter('deepseek', 'deepseek-chat'),
        openai = setup_adapter('openai', 'gpt-4.1'),
        xai = setup_adapter('xai', 'grok-3-beta'),
        venice = adapters.extend('openai_compatible', {
            name = 'venice',
            formatted_name = 'Venice',
            roles = {
                llm = 'assistant',
                user = 'user',
            },
            opts = {
                stream = true,
            },
            features = {
                text = true,
                tokens = true,
                vision = false,
            },
            env = {
                url = 'https://api.venice.ai/api',
                chat_url = '/v1/chat/completions',
                api_key = read_from_file('.venice'),
            },
            schema = {
                model = {
                    default = 'llama-3.1-405b',
                    -- Other models available:
                    --   deepseek-r1-671b
                    --   llama-3.1-405b
                    --   llama-3.2-3b
                    --   llama-3.3-70b
                    --   dolphin-2.9.2-qwen2-72b
                    --   deepseek-r1-llama-70b
                    --   deepseek-r1-671b
                    --   qwen2.5-coder-32b
                    --   qwen-2.5-vl
                },
                temperature = {
                    order = 2,
                    mapping = 'parameters',
                    type = 'number',
                    optional = true,
                    default = 0.8,
                    desc = 'What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.',
                    validate = function(n) return n >= 0 and n <= 2, 'Must be between 0 and 2' end,
                },
                max_completion_tokens = {
                    order = 3,
                    mapping = 'parameters',
                    type = 'integer',
                    optional = true,
                    default = nil,
                    desc = 'An upper bound for the number of tokens that can be generated for a completion.',
                    validate = function(n) return n > 0, 'Must be greater than 0' end,
                },
                presence_penalty = {
                    order = 4,
                    mapping = 'parameters',
                    type = 'number',
                    optional = true,
                    default = 0,
                    desc = "Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics.",
                    validate = function(n) return n >= -2 and n <= 2, 'Must be between -2 and 2' end,
                },
                top_p = {
                    order = 5,
                    mapping = 'parameters',
                    type = 'number',
                    optional = true,
                    default = 0.9,
                    desc = 'A higher value (e.g., 0.95) will lead to more diverse text, while a lower value (e.g., 0.5) will generate more focused and conservative text. (Default: 0.9)',
                    validate = function(n) return n >= 0 and n <= 1, 'Must be between 0 and 1' end,
                },
                stop = {
                    order = 6,
                    mapping = 'parameters',
                    type = 'string',
                    optional = true,
                    default = nil,
                    desc = 'Sets the stop sequences to use. When this pattern is encountered the LLM will stop generating text and return. Multiple stop patterns may be set by specifying multiple separate stop parameters in a modelfile.',
                    validate = function(s) return s:len() > 0, 'Cannot be an empty string' end,
                },
                frequency_penalty = {
                    order = 8,
                    mapping = 'parameters',
                    type = 'number',
                    optional = true,
                    default = 0,
                    desc = "Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim.",
                    validate = function(n) return n >= -2 and n <= 2, 'Must be between -2 and 2' end,
                },
                logit_bias = {
                    order = 9,
                    mapping = 'parameters',
                    type = 'map',
                    optional = true,
                    default = nil,
                    desc = 'Modify the likelihood of specified tokens appearing in the completion. Maps tokens (specified by their token ID) to an associated bias value from -100 to 100. Use https://platform.openai.com/tokenizer to find token IDs.',
                    subtype_key = {
                        type = 'integer',
                    },
                    subtype = {
                        type = 'integer',
                        validate = function(n) return n >= -100 and n <= 100, 'Must be between -100 and 100' end,
                    },
                },
            },
        }),
    },
})

vim.keymap.set({ 'n', 'x' }, '<Leader>cc', '<Cmd>CodeCompanionChat Toggle<CR>')
vim.keymap.set('x', 'ga', ':CodeCompanionChat Add<CR>')

local obsidian = require('obsidian')
obsidian.setup({
    ui = { enable = false },
    workspaces = {
        { path = vim.env.HOME .. '/Developer/personal/obsidian-notes' },
    },
    new_notes_location = 'notes_subdir',
    notes_subdir = 'notes',
    open_app_foreground = true,
    completion = {
        nvim_cmp = false,
        blink = true,
    },
    picker = {
        name = 'fzf-lua',
        note_mappings = {
            new = '<C-x>', -- Create a new note from your query.
            insert_link = '<C-l>', -- Insert a link to the selected note.
        },
        tag_mappings = {
            tag_note = '<C-x>', -- Add tag(s) to current note.
            insert_tag = '<C-l>', -- Insert a tag at the current location.
        },
    },
    open_notes_in = 'vsplit',
})
