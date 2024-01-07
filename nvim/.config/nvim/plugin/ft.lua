-- if a file is a .env or .envrc file, set the filetype to sh
vim.filetype.add({
    filename = {
        [".env"] = "fish",
        [".envrc"] = "fish",
        ["*.env"] = "fish",
        ["*.envrc"] = "fish",
        ["*.conf"] = "fish",
        ["*.theme"] = "fish",
        ["lfrc"] = "fish",
    },
})
