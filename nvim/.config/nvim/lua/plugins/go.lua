return {
    "ray-x/go.nvim",
    build = ':lua require("go.install").update_all_sync()',
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    dependencies = {
        "ray-x/guihua.lua",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
}
