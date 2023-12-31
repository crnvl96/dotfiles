local icons = {
    spinner = { "" },
    done = "  ",
}
local clients = {}
local wins_cnt = 0
vim.api.nvim_create_autocmd({ "LspProgress" }, {
    group = vim.api.nvim_create_augroup("lsp_progress", { clear = true }),
    pattern = "*",
    callback = function(args)
        if not args.data then
            return
        end

        local id = args.data.client_id
        if clients[id] == nil then
            clients[id] = {
                is_done = false,
                spinner_idx = 0,
            }
        end
        local output = ""
        local client_name = vim.lsp.get_client_by_id(id).name
        output = "[" .. client_name .. "]"
        local kind = args.data.result.value.kind
        local title = args.data.result.value.title
        if title then
            output = output .. " " .. title .. ":"
        end
        if kind == "end" then
            clients[id].is_done = true
            output = icons.done .. " " .. output .. " DONE!"
        else
            clients[id].is_done = false
            local msg = args.data.result.value.message
            local pct = args.data.result.value.percentage
            if msg then
                output = output .. " " .. msg
            end
            if pct then
                output = string.format("%s (%3d%%)", output, pct)
            end
            local idx = clients[id].spinner_idx
            idx = idx == #icons.spinner * 4 and 1 or idx + 1
            output = icons.spinner[math.ceil(idx / 4)] .. " " .. output
            clients[id].spinner_idx = idx
        end

        local win_row = clients[id].win_row
        if win_row == nil then
            win_row = vim.o.lines - vim.o.cmdheight - 3 - wins_cnt * 3
            clients[id].win_row = win_row
        end

        local winid = clients[id].winid
        local bufnr = clients[id].bufnr
        if winid == nil or not vim.api.nvim_win_is_valid(winid) or vim.api.nvim_win_get_tabpage(winid) ~= vim.api.nvim_get_current_tabpage() then
            bufnr = vim.api.nvim_create_buf(false, true)
            winid = vim.api.nvim_open_win(bufnr, false, {
                relative = "editor",
                width = #output,
                height = 1,
                row = win_row,
                col = vim.o.columns - #output,
                style = "minimal",
                noautocmd = true,
                border = vim.g.border_style,
            })
            clients[id].bufnr = bufnr
            clients[id].winid = winid
            wins_cnt = wins_cnt + 1
        else
            vim.api.nvim_win_set_config(winid, {
                relative = "editor",
                width = #output,
                row = win_row,
                col = vim.o.columns - #output,
            })
        end
        vim.wo[winid].winhl = "Normal:Normal"
        vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, { output })
        if clients[id].is_done then
            vim.defer_fn(function()
                if vim.api.nvim_win_is_valid(winid) then
                    vim.api.nvim_win_close(winid, true)
                end
                if vim.api.nvim_buf_is_valid(bufnr) then
                    vim.api.nvim_buf_delete(bufnr, { force = true })
                end
                wins_cnt = wins_cnt - 1
                clients[id].winid = nil
                clients[id].spinner_idx = 0
            end, 5000)
        end
    end,
})
