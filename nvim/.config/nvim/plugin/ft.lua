-- if a file is a .env or .envrc file, set the filetype to sh
vim.filetype.add({
    filename = {
        [".env"] = "sh",
        [".envrc"] = "sh",
        ["*.env"] = "sh",
        ["*.envrc"] = "sh",
        ["*.conf"] = "sh",
        ["*.theme"] = "sh",
        ["lfrc"] = "sh",
    },
})
