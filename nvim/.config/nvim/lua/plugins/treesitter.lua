return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        dependencies = {
            { "windwp/nvim-ts-autotag" },
            { "andymass/vim-matchup" },
        },
        init = function(plugin)
            require("lazy.core.loader").add_to_rtp(plugin)
            require("nvim-treesitter.query_predicates")
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end,
        opts = {
            autotag = { enable = true },
            matchup = { enable = true },
            indent = { enable = true },
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
                "gitcommit",
                "git_rebase",
                "go",
                "gomod",
                "gosum",
                "gowork",
                "javascript",
                "lua",
                "query",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
}
