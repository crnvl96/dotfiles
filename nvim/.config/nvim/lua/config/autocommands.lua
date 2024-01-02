vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("crnvl96_goto_last_buf_loc", { clear = true }),
    callback = function()
        local exclude = { "gitcommit" }
        local buf = vim.api.nvim_get_current_buf()
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
            return
        end
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("crnvl96_highlight_on_yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("crnvl96_set_node_path", { clear = true }),
    pattern = { "javascript, typescript, javascriptreact, typescriptreact" },
    callback = function()
        vim.g.node_host_prog = "/home/crnvl96/.asdf/shims/node"
        local home_dir = "/home/crnvl96"
        local node_bin = "/.asdf/installs/nodejs/20.8.1/bin"
        vim.g.node_host_prog = home_dir .. node_bin .. "/node"
        vim.cmd("let $PATH = '" .. home_dir .. node_bin .. ":' . $PATH")
    end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
    desc = "Clear LSP highlight groups",
    callback = function()
        for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
            vim.api.nvim_set_hl(0, group, {})
        end
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end
        require("functions.lsp").on_lsp_attach(client, args.buf)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function(args)
        local buffer = args.buf

        vim.cmd("clearjumps")

        vim.keymap.set("n", "J", function()
            local list = vim.fn.getqflist()
            local index = vim.api.nvim_win_get_cursor(0)[1]

            local current_filename = nil
            local next_filename = nil

            while index <= #list do
                local entry = list[index]
                local filename = vim.fn.bufname(entry.bufnr)

                if not current_filename then
                    current_filename = filename
                elseif filename ~= current_filename then
                    next_filename = filename
                    break
                end
                index = index + 1
            end

            if not current_filename or not next_filename then
                return
            end

            vim.api.nvim_win_set_cursor(0, { index, 0 })
        end, { buffer = buffer })

        vim.keymap.set("n", "K", function()
            local list = vim.fn.getqflist({ id = vim.fn.getqflist({ id = 0 }).id, items = 0 }).items

            if #list == 0 then
                return
            end
            local current_index = vim.api.nvim_win_get_cursor(0)[1]
            local current_filename = vim.fn.bufname(list[current_index].bufnr)

            local previous_filename = nil

            -- Maintain two indices. `start_index` tracks the first line among a group of
            -- entries for a filename. `index` tracks the entry we are currently looking at
            local start_index = 1
            local index = 1

            -- We search for the previous group of files by starting at the top. This
            -- simplifies the implementation since we are interested in jumping to
            -- the first entry among of a group of entries for the same filename
            while index < current_index do
                local entry = list[index]
                local filename = vim.fn.bufname(entry.bufnr)

                if filename ~= previous_filename then
                    previous_filename = filename
                    start_index = index
                end

                if filename == current_filename then
                    break
                end

                index = index + 1
            end

            if not previous_filename then
                return
            end

            vim.api.nvim_win_set_cursor(0, { start_index, 0 })
        end, { buffer = buffer })

        vim.keymap.set("n", "<CR>", function()
            local current_line = vim.api.nvim_win_get_cursor(0)[1]
            vim.cmd("keepjumps cc " .. current_line)
            vim.cmd("wincmd p")
        end, { buffer = buffer })
    end,
})
