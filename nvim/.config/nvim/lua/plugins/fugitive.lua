return {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gvdiffsplit", "Gwrite", "Gedit" },
    keys = {
        { "<leader>gx", "<cmd>Git mergetool --name-status<CR>", desc = "Open All Conflicts in QF" },
        { "<leader>gc", "<cmd>Git commit <bar> wincmd J<CR>", desc = "Commit" },
        { "<leader>gq", "<cmd>Git difftool --name-status<CR>", desc = "Open All Diffs in QF" },
        {
            "<leader>gl",
            "<cmd>Git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit<CR>",
            desc = "Log",
        },
    },
}
