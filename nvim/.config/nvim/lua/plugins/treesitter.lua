return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-textobjects" },
            { "windwp/nvim-ts-autotag" },
            { "echasnovski/mini.ai" },
            { "andymass/vim-matchup" },
        },
        init = function(plugin)
            require("lazy.core.loader").add_to_rtp(plugin)
            require("nvim-treesitter.query_predicates")
        end,
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = "popup" }

            local ai = require("mini.ai")
            ai.setup({
                n_lines = 300,
                custom_textobjects = {
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                    o = ai.gen_spec.treesitter({
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }, {}),
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
                    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
                },
                -- Disable error feedback.
                silent = true,
                -- Don't use the previous or next text object.
                search_method = "cover",
                mappings = {
                    -- Disable next/last variants.
                    around_next = "",
                    inside_next = "",
                    around_last = "",
                    inside_last = "",
                },
            })

            require("nvim-treesitter.configs").setup({
                indent = { enable = true },
                matchup = { enable = true },
                autotag = { enable = true },
                highlight = {
                    enable = true,
                    disable = function(_, buf)
                        if not vim.bo[buf].modifiable then
                            return false
                        end
                        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                        return ok and stats and stats.size > (250 * 1024)
                    end,
                },
                auto_install = true,
                ensure_installed = {
                    "c",
                    "lua",
                    "vim",
                    "vimdoc",
                    "query",
                    "gitcommit",
                    "git_rebase",
                    "go",
                    "gomod",
                    "gowork",
                    "gosum",
                    "typescript",
                    "tsx",
                    "javascript",
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<cr>",
                        node_incremental = "<cr>",
                        scope_incremental = false,
                        node_decremental = "<bs>",
                    },
                },
                textobjects = {
                    move = {
                        enable = true,
                        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
                        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
                        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
                        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
                    },
                },
            })
        end,
    },
}
