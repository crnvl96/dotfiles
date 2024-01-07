---@diagnostic disable: duplicate-set-field
return {
    {
        "stevearc/dressing.nvim",
        init = function()
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
        opts = {
            input = {
                win_options = {
                    winhighlight = "FloatBorder:LspFloatWinBorder",
                    winblend = 0,
                },
            },
            select = {
                trim_prompt = false,
                get_config = function(opts)
                    local winopts = { height = 0.6, width = 0.5 }

                    if opts.kind == "luasnip" then
                        opts.prompt = "Snippet choice: "
                        winopts = { height = 0.35, width = 0.3 }
                    end

                    if opts.prompt and not opts.prompt:match(":%s*$") then
                        opts.prompt = opts.prompt .. ": "
                    end

                    return {
                        backend = "fzf_lua",
                        fzf_lua = { winopts = winopts },
                    }
                end,
            },
        },
        config = function(_, opts)
            require("dressing").setup(opts)
        end,
    },
}
