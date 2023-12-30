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

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("crnvl96_enable_clue_triggers_fugitive", { clear = true }),
                pattern = { "fugitive" },
                callback = function(data)
                    miniclue.enable_buf_triggers(data.buf)
                end,
            })

            -- Add a-z/A-Z marks.
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

            -- Clues for recorded macros.
            local function macro_clues()
                local res = {}
                for _, register in ipairs(vim.split("abcdefghijklmnopqrstuvwxyz", "")) do
                    local keys = string.format('"%s', register)
                    local ok, desc = pcall(vim.fn.getreg, register, 1)
                    if ok and desc ~= "" then
                        table.insert(res, { mode = "n", keys = keys, desc = desc })
                        table.insert(res, { mode = "v", keys = keys, desc = desc })
                    end
                end

                return res
            end

            vim.api.nvim_set_hl(0, "MiniClueTitle", { link = "Normal" })
            vim.api.nvim_set_hl(0, "MiniClueBorder", { link = "Normal" })
            vim.api.nvim_set_hl(0, "MiniClueDescGroup", { link = "Normal" })
            vim.api.nvim_set_hl(0, "MiniClueDescSingle", { link = "Normal" })
            vim.api.nvim_set_hl(0, "MiniClueNextKey", { link = "Normal" })
            vim.api.nvim_set_hl(0, "MiniClueNextKeyWithPostKeys", { link = "Normal" })
            vim.api.nvim_set_hl(0, "MiniClueSeparator", { link = "Normal" })

            return {
                triggers = {
                    -- Builtins.
                    { mode = "n", keys = "g" },
                    { mode = "x", keys = "g" },
                    { mode = "n", keys = "`" },
                    { mode = "x", keys = "`" },
                    { mode = "n", keys = '"' },
                    { mode = "x", keys = '"' },
                    { mode = "i", keys = "<C-r>" },
                    { mode = "c", keys = "<C-r>" },
                    { mode = "n", keys = "<C-w>" },
                    { mode = "n", keys = "z" },
                    -- Leader triggers.
                    { mode = "n", keys = "<leader>" },
                    { mode = "x", keys = "<leader>" },
                    -- Moving between stuff.
                    { mode = "n", keys = "[" },
                    { mode = "n", keys = "]" },
                    -- surround
                    { mode = "n", keys = "y" },
                    { mode = "n", keys = "d" },
                    { mode = "n", keys = "c" },
                    -- textobjects
                    { mode = "x", keys = "i" },
                    { mode = "x", keys = "a" },
                },
                clues = {
                    { mode = "n", keys = "<leader>b", desc = "+buffers" },
                    { mode = "n", keys = "<leader>c", desc = "+code" },
                    { mode = "x", keys = "<leader>c", desc = "+code" },
                    { mode = "n", keys = "<leader>d", desc = "+dap" },
                    { mode = "x", keys = "<leader>d", desc = "+dap" },
                    { mode = "n", keys = "<leader>f", desc = "+find" },
                    { mode = "x", keys = "<leader>f", desc = "+find" },
                    { mode = "n", keys = "<leader>g", desc = "+git" },
                    { mode = "x", keys = "<leader>g", desc = "+git" },
                    { mode = "n", keys = "<leader>o", desc = "+overseer" },
                    { mode = "n", keys = "<leader>s", desc = "+search" },
                    { mode = "x", keys = "<leader>s", desc = "+search" },
                    { mode = "x", keys = "<leader>t", desc = "+test" },
                    { mode = "n", keys = "<leader>w", desc = "+windows" },
                    { mode = "n", keys = "[", desc = "+prev" },
                    { mode = "n", keys = "]", desc = "+next" },
                    -- Useful builtins.
                    miniclue.gen_clues.marks(),
                    miniclue.gen_clues.registers(),
                    mark_clues,
                    macro_clues,
                    -- Clues for g mappings.
                    { mode = "n", keys = "g'", desc = "Jump to mark (don't affect jumplist)" },
                    { mode = "n", keys = "g*", desc = "Search word under cursor" },
                    { mode = "n", keys = "gE", desc = "Go backwards to end of previous WORD" },
                    { mode = "n", keys = "gT", desc = "Go to previous tabpage" },
                    { mode = "n", keys = "g`", desc = "Jump to mark (don't affect jumplist)" },
                    { mode = "n", keys = "ga", desc = "Print ascii value" },
                    { mode = "n", keys = "ge", desc = "Go backwards to end of previous word" },
                    { mode = "n", keys = "gg", desc = "Go to line (def: first)" },
                    { mode = "n", keys = "gq", desc = "Format text (operator)" },
                    { mode = "n", keys = "gt", desc = "Go to next tabpage" },
                    { mode = "n", keys = "gx", desc = "Execute app for file under cursor" },
                    -- Clues for z mappings.
                    { mode = "n", keys = "z=", desc = "Show spelling suggestions" },
                    { mode = "n", keys = "zA", desc = "Toggle folds recursively" },
                    { mode = "n", keys = "zC", desc = "Close folds recursively" },
                    { mode = "n", keys = "zF", desc = "Create fold" },
                    { mode = "n", keys = "zM", desc = "Close all folds" },
                    { mode = "n", keys = "zO", desc = "Open folds recursively" },
                    { mode = "n", keys = "zR", desc = "Open all folds" },
                    { mode = "n", keys = "za", desc = "Toggle fold" },
                    { mode = "n", keys = "zb", desc = "Redraw at bottom" },
                    { mode = "n", keys = "zc", desc = "Close fold" },
                    { mode = "n", keys = "zf", desc = "Create fold (operator)" },
                    { mode = "n", keys = "zi", desc = "Toggle 'foldenable'" },
                    { mode = "n", keys = "zj", desc = "Move to start of next fold" },
                    { mode = "n", keys = "zk", desc = "Move to end of previous fold" },
                    { mode = "n", keys = "zm", desc = "Fold more" },
                    { mode = "n", keys = "zo", desc = "Open fold" },
                    { mode = "n", keys = "zr", desc = "Fold less" },
                    { mode = "n", keys = "zt", desc = "Redraw at top" },
                    { mode = "n", keys = "zv", desc = "Open enough folds" },
                    { mode = "n", keys = "zx", desc = "Update folds + open enough folds" },
                    -- Clues for window mappings.
                    { mode = "n", keys = "<C-w>=", desc = "Make windows same dimensions" },
                    { mode = "n", keys = "<C-w>F", desc = "Split + edit file name + jump" },
                    { mode = "n", keys = "<C-w>H", desc = "Move to very left" },
                    { mode = "n", keys = "<C-w>J", desc = "Move to very bottom" },
                    { mode = "n", keys = "<C-w>K", desc = "Move to very top" },
                    { mode = "n", keys = "<C-w>L", desc = "Move to very right" },
                    { mode = "n", keys = "<C-w>R", desc = "Rotate up/left" },
                    { mode = "n", keys = "<C-w>c", desc = "Close" },
                    { mode = "n", keys = "<C-w>f", desc = "Split + edit file name" },
                    { mode = "n", keys = "<C-w>n", desc = "Open new" },
                    { mode = "n", keys = "<C-w>o", desc = "Close all but current" },
                    { mode = "n", keys = "<C-w>q", desc = "Quit current" },
                    { mode = "n", keys = "<C-w>r", desc = "Rotate down/right" },
                    { mode = "n", keys = "<C-w>s", desc = "Split horizontally" },
                    { mode = "n", keys = "<C-w>v", desc = "Split vertically" },
                    { mode = "n", keys = "<C-w>x", desc = "Exchange windows" },
                    -- textobjects
                    { mode = "x", keys = "if", desc = "Inside function" },
                    { mode = "x", keys = "io", desc = "Inside block" },
                    { mode = "x", keys = "ic", desc = "Inside class" },
                    { mode = "x", keys = "it", desc = "Inside tag" },

                    { mode = "x", keys = "af", desc = "Around function" },
                    { mode = "x", keys = "ao", desc = "Around block" },
                    { mode = "x", keys = "ac", desc = "Around class" },
                    { mode = "x", keys = "at", desc = "Around tag" },

                    { mode = "x", keys = "i(", desc = "Inside ()" },
                    { mode = "x", keys = "i)", desc = "Inside () w/space" },
                    { mode = "x", keys = "i[", desc = "Inside []" },
                    { mode = "x", keys = "i]", desc = "Inside [] w/space" },
                    { mode = "x", keys = "i{", desc = "Inside {}" },
                    { mode = "x", keys = "i}", desc = "Inside {} w/ space" },
                    { mode = "x", keys = "i<", desc = "Inside <> w/ space" },
                    { mode = "x", keys = "i>", desc = "Inside <> w/ space" },
                    { mode = "x", keys = "ib", desc = "Inside <{[()]}> w/ space" },

                    { mode = "x", keys = "a(", desc = "Around ()" },
                    { mode = "x", keys = "a)", desc = "Around () w/space" },
                    { mode = "x", keys = "a[", desc = "Around []" },
                    { mode = "x", keys = "a]", desc = "Around [] w/space" },
                    { mode = "x", keys = "a{", desc = "Around {}" },
                    { mode = "x", keys = "a}", desc = "Around {} w/ space" },
                    { mode = "x", keys = "a<", desc = "Around <>" },
                    { mode = "x", keys = "a>", desc = "Around <> w/ space" },
                    { mode = "x", keys = "ab", desc = "Around <{[()]}> w/ space" },

                    { mode = "x", keys = "i'", desc = "Inside '" },
                    { mode = "x", keys = 'i"', desc = 'Inside "' },
                    { mode = "x", keys = "i`", desc = "Inside `" },
                    { mode = "x", keys = "iq", desc = "Inside '`\"" },

                    { mode = "x", keys = "a'", desc = "Around '" },
                    { mode = "x", keys = 'a"', desc = 'Around "' },
                    { mode = "x", keys = "a`", desc = "Around `" },
                    { mode = "x", keys = "aq", desc = "Around '`\"" },

                    { mode = "x", keys = "i?", desc = "Inside prompt" },
                    { mode = "x", keys = "a?", desc = "Around prompt" },

                    { mode = "n", keys = "dv", postkeys = "d", desc = "(Fugitive diff)" },
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
    },
}
