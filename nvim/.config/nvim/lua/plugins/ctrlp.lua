return {
    {
        "ctrlpvim/ctrlp.vim",
        lazy = false,
        init = function()
            vim.cmd([[
              let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
              let g:ctrlp_prompt_mappings = {
                \ 'PrtSelectMove("j")':   ['<c-n>', '<down>'],
                \ 'PrtSelectMove("k")':   ['<c-p>', '<up>'],
                \ 'PrtHistory(-1)':       [],
                \ 'PrtHistory(1)':        [],
                \ 'ToggleByFname()':      [],
                \ }
            ]])

            vim.api.nvim_create_user_command("Grep", function(search_args)
                local cmdline = { "rg", "--vimgrep", "--smart-case", search_args.args }
                local rg_result = vim.fn.system(cmdline)

                if vim.v.shell_error == 1 and rg_result == "" then
                    vim.notify("No matches found", vim.log.levels.WARN)
                    return
                end

                if vim.v.shell_error ~= 0 then
                    error("Command failed with error code: " .. vim.v.shell_error .. "\n" .. rg_result)
                end

                local lines = vim.fn.map(vim.split(rg_result, "\n", { trimempty = true }), function(_, item)
                    local next = string.gmatch(item, "([^:]+):(%d+):(%d+):(.*)")
                    local filename, line, col, text = next()
                    return {
                        filename = filename,
                        lnum = line,
                        col = col,
                        vcol = 1,
                        text = text,
                    }
                end)

                vim.fn.setqflist({}, "r", {
                    id = vim.fn.getqflist({ id = 0 }).id,
                    items = lines,
                    title = table.concat(cmdline, " "),
                })

                vim.cmd("copen")
            end, {
                desc = "Recursively search for a pattern within the files in the current directory",
                nargs = 1,
            })
        end,
        keymaps = {
            { "<C-u>", "<cmd>CtrlPBuffer<CR>" },
            { "<C-y>", "<cmd>CtrlPMRU<CR>" },
            { "<C-n>", "<cmd>CtrlPLine<CR>" },
        },
    },
    -- {
    --     "ibhagwan/fzf-lua",
    --     cmd = "FzfLua",
    --     init = function()
    --         vim.api.nvim_create_user_command("Grep", function(search_args)
    --             local cmdline = { "rg", "--vimgrep", "--smart-case", search_args.args }
    --             local rg_result = vim.fn.system(cmdline)
    --
    --             if vim.v.shell_error == 1 and rg_result == "" then
    --                 vim.notify("No matches found", vim.log.levels.WARN)
    --                 return
    --             end
    --
    --             if vim.v.shell_error ~= 0 then
    --                 error("Command failed with error code: " .. vim.v.shell_error .. "\n" .. rg_result)
    --             end
    --
    --             local lines = vim.fn.map(vim.split(rg_result, "\n", { trimempty = true }), function(_, item)
    --                 local next = string.gmatch(item, "([^:]+):(%d+):(%d+):(.*)")
    --                 local filename, line, col, text = next()
    --                 return {
    --                     filename = filename,
    --                     lnum = line,
    --                     col = col,
    --                     vcol = 1,
    --                     text = text,
    --                 }
    --             end)
    --
    --             vim.fn.setqflist({}, "r", {
    --                 id = vim.fn.getqflist({ id = 0 }).id,
    --                 items = lines,
    --                 title = table.concat(cmdline, " "),
    --             })
    --
    --             vim.cmd("copen")
    --         end, {
    --             desc = "Recursively search for a pattern within the files in the current directory",
    --             nargs = 1,
    --         })
    --     end,
    --     config = function()
    --         local actions = require("fzf-lua.actions")
    --         require("fzf-lua").setup({
    --             file_ignore_patterns = { "%.svg$", "node_modules$", "%-lock.json$" },
    --             fzf_opts = {
    --                 ["--info"] = "default",
    --                 ["--layout"] = "reverse-list",
    --                 ["--cycle"] = "",
    --             },
    --             winopts = {
    --                 height = 0.9,
    --                 width = 0.8,
    --                 preview = {
    --                     scrollbar = false,
    --                     layout = "vertical",
    --                     vertical = "up:40%",
    --                 },
    --             },
    --             keymap = {
    --                 builtin = {
    --                     ["<M-p>"] = "toggle-preview",
    --                 },
    --                 fzf = {
    --                     ["esc"] = "abort",
    --                     ["ctrl-q"] = "select-all+accept",
    --                     ["alt-p"] = "toggle-preview",
    --                     ["ctrl-o"] = "toggle-all",
    --                 },
    --             },
    --             files = {
    --                 winopts = {
    --                     preview = { hidden = "hidden" },
    --                 },
    --                 actions = {
    --                     ["default"] = actions.file_edit_or_qf,
    --                     ["alt-q"] = actions.file_sel_to_qf,
    --                 },
    --             },
    --             lsp = {
    --                 code_actions = {
    --                     previewer = "codeaction_native",
    --                     preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS --hunk-header-style='omit' --file-style='omit'",
    --                 },
    --             },
    --             helptags = {
    --                 actions = {
    --                     ["default"] = actions.help_vert,
    --                 },
    --             },
    --             oldfiles = {
    --                 include_current_session = true,
    --                 winopts = {
    --                     preview = { hidden = "hidden" },
    --                 },
    --             },
    --             buffers = {
    --                 actions = {
    --                     ["default"] = actions.buf_edit,
    --                     ["ctrl-d"] = { fn = actions.buf_del, reload = true },
    --                 },
    --             },
    --         })
    --     end,
    --     keys = {
    --         { "<leader>sg", "<cmd>FzfLua live_grep_glob<cr>", desc = "Grep" },
    --         { "<leader>sg", "<cmd>FzfLua grep_visual<cr>", desc = "Grep", mode = "x" },
    --         { "<leader>sb", "<cmd>FzfLua lgrep_curbuf<cr>", desc = "Grep Current Buffer" },
    --         { "<leader>sr", "<cmd>FzfLua resume<cr>", desc = "Resume" },
    --         { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help" },
    --         { "<leader>fo", "<cmd>FzfLua oldfiles<cr>", desc = "Recently opened files" },
    --         { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
    --         { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Find Buffers" },
    --         { "<leader>fh", "<cmd>FzfLua highlights<cr>", desc = "Highlights" },
    --         {
    --             "<leader>fq",
    --             function()
    --                 vim.cmd("ccl")
    --                 require("fzf-lua").quickfix()
    --             end,
    --             desc = "QF",
    --         },
    --     },
    -- },
}
