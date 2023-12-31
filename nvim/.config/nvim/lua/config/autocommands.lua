vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("crnvl96_close_with_q", { clear = true }),
    desc = "Close with <q>",
    pattern = {
        "help",
        "man",
        "qf",
        "query",
        "scratch",
        "spectre_panel",
        "checkhealth",
    },
    callback = function(args)
        vim.keymap.set("n", "q", "<cmd>quit<cr>", { buffer = args.buf })
    end,
})

vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("crnvl96_open_link_in_browser", { clear = true }),
    desc = "Special dotfiles setup",
    callback = function()
        local ok, inside_dotfiles = pcall(vim.startswith, vim.fn.getcwd(), vim.env.XDG_CONFIG_HOME)
        if not ok or not inside_dotfiles then
            return
        end
        vim.env.GIT_WORK_TREE = vim.env.HOME
        vim.env.GIT_DIR = vim.env.HOME .. "/.cfg"

        vim.keymap.set("n", "gx", function()
            local file = vim.fn.expand("<cfile>") --[[@as string]]
            local _, err = vim.ui.open(file)
            if not err then
                return
            end
            local link = file:match("%w[%w%-]+/[%w%-%._]+")
            if link then
                _, err = vim.ui.open("https://www.github.com/" .. link)
            end
            if err then
                vim.notify(err, vim.log.levels.ERROR)
            end
        end, { desc = "Open filepath or URI under cursor" })
    end,
})

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

vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("crnvl96_disable_autocomment", { clear = true }),
    command = [[set formatoptions-=cro]],
})

vim.api.nvim_create_autocmd("Colorscheme", {
    group = vim.api.nvim_create_augroup("crnvl96_colorscheme", { clear = true }),
    callback = function()
        vim.api.nvim_set_hl(0, "StatusLine", { bg = "#30363d" })
    end,
})

local cursorGrp = vim.api.nvim_create_augroup("CursorLine", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
    pattern = "*",
    command = "set cursorline",
    group = cursorGrp,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, { pattern = "*", command = "set nocursorline", group = cursorGrp })

vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("crnvl96_set_signcolumn_marks", { clear = true }),
    callback = function()
        require("utils.marks_handler").set_keymaps()
    end,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
    group = vim.api.nvim_create_augroup("crnvl96_refresh_signcolumn_marks", { clear = true }),
    callback = function(args)
        require("utils.marks_handler").BufWinEnterHandler(args)
    end,
})
