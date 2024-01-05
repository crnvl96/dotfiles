return {
    {
        "ibhagwan/fzf-lua",
        cmd = "FzfLua",
        config = function()
            local actions = require("fzf-lua.actions")
            require("fzf-lua").setup({
                file_ignore_patterns = { "%.svg$", "node_modules$", "%-lock.json$" },
                fzf_opts = {
                    ["--info"] = "default",
                    ["--layout"] = "reverse-list",
                    ["--cycle"] = "",
                },
                winopts = {
                    height = 0.9,
                    width = 0.8,
                    preview = {
                        scrollbar = false,
                        layout = "vertical",
                        vertical = "up:40%",
                    },
                },
                keymap = {
                    builtin = {
                        ["<m-p>"] = "toggle-preview",
                    },
                    fzf = {
                        ["esc"] = "abort",
                        ["ctrl-q"] = "select-all+accept",
                        ["alt-p"] = "toggle-preview",
                        ["ctrl-o"] = "toggle-all",
                    },
                },
                files = {
                    winopts = {
                        preview = { hidden = "hidden" },
                    },
                    actions = {
                        ["default"] = actions.file_edit_or_qf,
                        ["alt-q"] = actions.file_sel_to_qf,
                    },
                },
                lsp = {
                    code_actions = {
                        previewer = "codeaction_native",
                        preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS --hunk-header-style='omit' --file-style='omit'",
                    },
                },
                helptags = {
                    actions = {
                        ["default"] = actions.help_vert,
                    },
                },
                oldfiles = {
                    include_current_session = true,
                    winopts = {
                        preview = { hidden = "hidden" },
                    },
                },
                buffers = {
                    actions = {
                        ["default"] = actions.buf_edit,
                        ["ctrl-d"] = { fn = actions.buf_del, reload = true },
                    },
                },
            })
        end,
        keys = {
            { "<leader>sg", "<cmd>FzfLua live_grep_glob<cr>", desc = "Grep" },
            { "<leader>sg", "<cmd>FzfLua grep_visual<cr>", desc = "Grep", mode = "x" },
            { "<leader>sb", "<cmd>FzfLua lgrep_curbuf<cr>", desc = "Grep Current Buffer" },
            { "<leader>sr", "<cmd>FzfLua resume<cr>", desc = "Resume" },
            { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help" },
            { "<leader>fo", "<cmd>FzfLua oldfiles<cr>", desc = "Recently opened files" },
            { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
            { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Find Buffers" },
            { "<leader>fh", "<cmd>FzfLua highlights<cr>", desc = "Highlights" },
        },
    },
}
