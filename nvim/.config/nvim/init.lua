require("config")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.cmd.colorscheme("default")

require("lazy").setup({
    ui = { border = "rounded" },
    dev = { path = vim.g.projects_dir },
    install = {
        missing = true,
    },
    change_detection = { notify = false },
    spec = {
        { import = "plugins" },
    },
    defaults = {
        lazy = true,
        version = false,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                -- "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
