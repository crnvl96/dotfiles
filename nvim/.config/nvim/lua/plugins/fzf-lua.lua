return {
    {
        "ibhagwan/fzf-lua",
        cmd = "FzfLua",
        event = "VeryLazy",
        config = function()
            local clue = require("mini.clue")
            clue.config.clues = vim.list_extend(clue.config.clues, {
                { mode = "n", keys = "<leader>f", desc = "+find" },
                { mode = "x", keys = "<leader>f", desc = "+find" },
                { mode = "n", keys = "<leader>s", desc = "+search" },
                { mode = "x", keys = "<leader>s", desc = "+search" },
            })

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
                    on_create = function()
                        vim.keymap.set("t", "<C-r>", [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true })
                    end,
                },
                keymap = {
                    builtin = {
                        ["<M-p>"] = "toggle-preview",
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
            {
                "<leader>fq",
                function()
                    vim.cmd("ccl")
                    require("fzf-lua").quickfix()
                end,
                desc = "QF",
            },
        },
    },
}
