return {
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            jump = { nohlsearch = true },
            prompt = {
                win_config = { row = -3 },
            },
            search = {
                exclude = {
                    "cmp_menu",
                    "flash_prompt",
                    "qf",
                    function(win)
                        if vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win)):match("BqfPreview") then
                            return true
                        end
                        return not vim.api.nvim_win_get_config(win).focusable
                    end,
                },
            },
        },
        config = function(_, opts)
            require("flash").setup(opts)
        end,
        -- stylua: ignore
        keys = {
            {"s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash",},
            {"r", mode = "o", function() require("flash").treesitter_search() end, desc = "Treesitter Search",},
        },
    },
}
