local brew = '/home/linuxbrew/.linuxbrew/bin/'

vim.lsp.config.lua_ls = {
    cmd = { brew .. 'lua-language-server' },

    filetypes = { 'lua' },

    single_file_support = true,

    root_dir = function(buffer, cb)
        local file_patterns = {
            '.luarc.json',
        }

        if buffer then
            local root = vim.fs.root(buffer, file_patterns)
            if root then return cb(root) end
        end
    end,

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
            runtime = {
                version = 'LuaJIT',
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    '$VIMRUNTIME',
                    '$XDG_DATA_HOME/nvim/site/pack/deps/opt',
                    '${3rd}/luv/library',
                },
            },
        })
    end,
}
