return {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gvdiffsplit" },
    keys = {
        { "<leader>gg", "<cmd>Git<CR>", desc = "Git" },
        {
            "<leader>gl",
            "<cmd>Git log --decorate --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit<CR>",
            desc = "Git log",
        },
        {
            "<leader>gd",
            "<cmd>Gvdiffsplit!<CR>",
            desc = "Git diff this",
        },
        {
            "<leader>gc",
            "<cmd>Git commit <bar> wincmd J<CR>",
            desc = "Commit staged changes",
        },
        {
            "<leader>ga",
            "<cmd>Git commit --amend <bar> wincmd J<CR>",
            desc = "Amend the last commit",
        },
        {
            "<leader>gP",
            "<cmd>Git push<CR>",
            desc = "Git push",
        },
        {
            "<leader>gp",
            "<cmd>Git pull<CR>",
            desc = "Git pull",
        },
        {
            "<leader>gD",
            "<cmd>Git difftool --name-status<CR>",
            desc = "Git difftool",
        },
        {
            "<leader>gq",
            "<cmd>call fugitive#DiffClose()<CR>",
            desc = "Close diff",
        },
        {
            "<leader>gx",
            "<cmd>Git mergetool --name-status<CR>",
            desc = "Git mergetool",
        },
    },
}
