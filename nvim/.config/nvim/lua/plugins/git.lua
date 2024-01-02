return {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gvdiffsplit" },
    init = function()
        vim.api.nvim_create_user_command("Gdiff", function()
            vim.cmd("Gvdiffsplit!")
        end, { desc = "Diff a file against its remote", nargs = 0 })

        vim.api.nvim_create_user_command("Glog", function()
            vim.cmd(
                "Git log --decorate --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
            )
        end, { desc = "Render git log for this repo", nargs = 0 })
    end,
}
