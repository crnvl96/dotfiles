return {
    {
        "stevearc/dressing.nvim",
        opts = {
            input = {
                win_options = {
                    winhighlight = "Float:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
                    winblend = 0,
                },
                insert_only = false,
                relative = "editor",
            },
            select = {
                trim_prompt = false,
                get_config = function(opts)
                    local winopts = { height = 0.6, width = 0.5 }

                    -- Add a colon to the prompt if it doesn't have one.
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
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
    },
}
