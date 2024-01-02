return {
    {
        "echasnovski/mini.clue",
        event = "VeryLazy",
        opts = function()
            local miniclue = require("mini.clue")

            vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost", "BufNewFile", "BufWritePost" }, {
                group = vim.api.nvim_create_augroup("crnvl96_enable_clue_triggers", { clear = true }),
                callback = function(data)
                    miniclue.enable_buf_triggers(data.buf)
                end,
            })

            local function mark_clues()
                local marks = {}
                vim.list_extend(marks, vim.fn.getmarklist(vim.api.nvim_get_current_buf()))
                vim.list_extend(marks, vim.fn.getmarklist())

                return vim.iter.map(function(mark)
                    local key = mark.mark:sub(2, 2)

                    -- Just look at letter marks.
                    if not string.match(key, "^%a") then
                        return nil
                    end

                    -- For global marks, use the file as a description.
                    -- For local marks, use the line number and content.
                    local desc
                    if mark.file then
                        desc = vim.fn.fnamemodify(mark.file, ":p:~:.")
                    elseif mark.pos[1] and mark.pos[1] ~= 0 then
                        local line_num = mark.pos[2]
                        local lines = vim.fn.getbufline(mark.pos[1], line_num)
                        if lines and lines[1] then
                            desc = string.format("%d: %s", line_num, lines[1]:gsub("^%s*", ""))
                        end
                    end

                    if desc then
                        return { mode = "n", keys = string.format("`%s", key), desc = desc }
                    end
                end, marks)
            end

            return {
                triggers = {
                    { mode = "n", keys = "<Leader>" },
                    { mode = "x", keys = "<Leader>" },

                    -- Built-in completion
                    { mode = "i", keys = "<C-x>" },

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

                    -- `z` key
                    { mode = "n", keys = "z" },
                    { mode = "x", keys = "z" },

                    -- next/prev
                    { mode = "n", keys = "[" },
                    { mode = "n", keys = "]" },
                },
                clues = {
                    -- next/prev clues
                    { mode = "n", keys = "[", desc = "+prev" },
                    { mode = "n", keys = "]", desc = "+next" },

                    -- Useful builtins.
                    miniclue.gen_clues.builtin_completion(),
                    miniclue.gen_clues.g(),
                    miniclue.gen_clues.windows(),
                    miniclue.gen_clues.z(),
                    miniclue.gen_clues.marks(),
                    miniclue.gen_clues.registers(),
                    mark_clues,
                },
                window = {
                    delay = 200,
                    config = function(bufnr)
                        local max_width = 0
                        for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
                            max_width = math.max(max_width, vim.fn.strchars(line))
                        end

                        -- Keep some right padding.
                        max_width = max_width + 2

                        return {
                            border = "rounded",
                            -- Dynamic width capped at 45.
                            width = math.min(45, max_width),
                        }
                    end,
                },
            }
        end,
    },
}
