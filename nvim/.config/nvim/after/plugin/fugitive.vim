if exists('g:loaded_fugitive')
lua <<EOF
    vim.keymap.set("n", "<leader>gg", "<cmd>Git<CR>", { desc = "Git" })
    vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit!<CR>", { desc = "Git diff" })
    vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<bar>wincmd j<CR>", { desc = "Git commit" })
    vim.keymap.set("n", "<leader>gp", "<cmd>Git pull<CR>", { desc = "Git pull" })
    vim.keymap.set("n", "<leader>gP", "<cmd>Git push<CR>", { desc = "Git push" })
EOF
endif
