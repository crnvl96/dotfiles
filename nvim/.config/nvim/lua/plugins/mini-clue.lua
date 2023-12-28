return {
    {
        "echasnovski/mini.clue",
        event = "VeryLazy",
        init = function()
            vim.api.nvim_set_hl(0, "MiniClueTitle", { link = "FloatBorder" })
        end,
        opts = function()
            local miniclue = require("mini.clue")

            return {
                triggers = {
                    -- `g` key
                    { mode = "n", keys = "g" },
                    { mode = "x", keys = "g" },

                    -- Marks
                    { mode = "n", keys = "'" },
                    { mode = "n", keys = "`" },
                    { mode = "x", keys = "'" },
                    { mode = "x", keys = "`" },

                    -- Registers
                    { mode = "n", keys = '"' },
                    { mode = "x", keys = '"' },
                    { mode = "i", keys = "<C-r>" },
                    { mode = "c", keys = "<C-r>" },

                    -- Window commands
                    { mode = "n", keys = "<C-w>" },

                    -- Leader triggers
                    { mode = "n", keys = "<leader>" },
                    { mode = "x", keys = "<leader>" },

                    -- Built-in completion
                    { mode = "i", keys = "<C-x>" },

                    -- `z` key
                    { mode = "n", keys = "z" },
                    { mode = "x", keys = "z" },

                    -- fugitive
                    { mode = "n", keys = "d" },
                    { mode = "n", keys = "c" },
                },
                clues = {
                    miniclue.gen_clues.marks(),
                    miniclue.gen_clues.registers(),
                    miniclue.gen_clues.builtin_completion(),
                    miniclue.gen_clues.g(),
                    miniclue.gen_clues.windows(),
                    miniclue.gen_clues.z(),

                    { mode = "n", keys = "<leader>b", desc = "+buffers" },
                    { mode = "n", keys = "<leader>c", desc = "+code" },
                    { mode = "x", keys = "<leader>c", desc = "+code" },
                    { mode = "n", keys = "<leader>f", desc = "+find" },
                    { mode = "x", keys = "<leader>f", desc = "+find" },
                    { mode = "n", keys = "<leader>g", desc = "+git" },
                    { mode = "x", keys = "<leader>g", desc = "+git" },
                    { mode = "n", keys = "<leader>s", desc = "+search" },
                    { mode = "x", keys = "<leader>s", desc = "+search" },
                    { mode = "n", keys = "<leader>w", desc = "+windows" },
                    { mode = "n", keys = "[", desc = "+prev" },
                    { mode = "n", keys = "]", desc = "+next" },
                },
                window = {
                    delay = 200,
                    scroll_down = "<C-f>",
                    scroll_up = "<C-b>",
                    config = function(bufnr)
                        local max_width = 0
                        for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
                            max_width = math.max(max_width, vim.fn.strchars(line))
                        end

                        max_width = max_width + 2

                        return {
                            border = "rounded",
                            width = max_width,
                        }
                    end,
                },
            }
        end,
        config = function(_, opts)
            require("mini.clue").setup(opts)
        end,
    },
}
