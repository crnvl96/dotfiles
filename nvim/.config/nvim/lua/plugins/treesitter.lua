return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        dependencies = {
            "windwp/nvim-ts-autotag",
        },
        init = function(plugin)
            require("lazy.core.loader").add_to_rtp(plugin)
            require("nvim-treesitter.query_predicates")
        end,
        config = function()
            require("nvim-treesitter.configs").setup({
                autotag = { enable = true },
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
            })
        end,
    },
}
