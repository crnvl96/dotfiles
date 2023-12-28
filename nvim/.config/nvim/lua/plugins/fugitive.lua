return {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gvdiffsplit", "Gwrite", "Gedit" },
    keys = {
        { "<leader>gg", "<cmd>G<CR>", desc = "Git" },
        { "<leader>gx", "<cmd>Git mergetool --name-status<CR>", desc = "Open All Conflicts in QF" },
        { "<leader>gc", "<cmd>Git commit <bar> wincmd J<CR>", desc = "Commit" },
        { "<leader>gw", "<cmd>Gwrite<CR>", desc = "Stage Buffer" },
        { "<leader>ge", "<cmd>Gedit<CR>", desc = "Restore Buffer" },
        { "<leader>gq", "<cmd>Git difftool --name-status<CR>", desc = "Open All Diffs in QF" },
        { "<leader>gd", "<cmd>Gvdiffsplit!<CR>", desc = "Diff Current File" },
    },
}
