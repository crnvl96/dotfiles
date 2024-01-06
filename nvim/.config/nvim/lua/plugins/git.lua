return {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gvdiffsplit" },
    keys = {
        { "<leader>gg", "<cmd>Git<cr>", desc = "Git" },
        {
            "<leader>gl",
            "<cmd>Git log --decorate --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit<cr>",
            desc = "Git log",
        },
        {
            "<leader>gd",
            "<cmd>Gvdiffsplit!<cr>",
            desc = "Git diff this",
        },
        {
            "<leader>gc",
            "<cmd>Git commit <bar> wincmd J<cr>",
            desc = "Commit staged changes",
        },
        {
            "<leader>ga",
            "<cmd>Git commit --amend <bar> wincmd J<cr>",
            desc = "Amend the last commit",
        },
        {
            "<leader>gP",
            "<cmd>Git push<cr>",
            desc = "Git push",
        },
        {
            "<leader>gp",
            "<cmd>Git pull<cr>",
            desc = "Git pull",
        },
        {
            "<leader>gD",
            "<cmd>Git difftool --name-status<cr>",
            desc = "Git difftool",
        },
        {
            "<leader>gq",
            "<cmd>call fugitive#DiffClose()<cr>",
            desc = "Close diff",
        },
        {
            "<leader>gx",
            "<cmd>Git mergetool --name-status<cr>",
            desc = "Git mergetool",
        },
    },
}
