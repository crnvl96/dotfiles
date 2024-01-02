-- Create buffer-local mappings for the quickfix list
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function(args)
        local buffer = args.buf

        vim.cmd("clearjumps")

        -- Using <Control + j> moves the cursor to the next entry in the list that
        -- has a different filename
        vim.keymap.set("n", "<C-n>", function()
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

            -- Got to the end of the qflist without finding the next filename to go
            -- to
            if not current_filename or not next_filename then
                return
            end

            vim.api.nvim_win_set_cursor(0, { index, 0 })
        end, { buffer = buffer })

        -- Using <Control + k> moves the cursor to first entry that has a different
        -- filename and appears before the entry the cursor is currently on
        vim.keymap.set("n", "<C-p>", function()
            local list = vim.fn.getqflist({ id = vim.fn.getqflist({ id = 0 }).id, items = 0 }).items

            if #list == 0 then
                return
            end
            -- Current location of the cursor
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

        -- Hitting <Enter> opens the file in a buffer then jumps back to the quickfix list
        vim.keymap.set("n", "<CR>", function()
            local current_line = vim.api.nvim_win_get_cursor(0)[1]
            vim.cmd("keepjumps cc " .. current_line)
            vim.cmd("wincmd p")
        end, { buffer = buffer })
    end,
})

-- Close the quickfix window if it is the last window open
vim.api.nvim_create_autocmd("WinEnter", {
    callback = function()
        local windows = vim.api.nvim_tabpage_list_wins(0)

        if #windows == 1 and vim.opt.buftype:get() == "quickfix" then
            vim.cmd("quit")
        end
    end,
})
