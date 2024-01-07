return {
    "ray-x/go.nvim",
    build = ':lua require("go.install").update_all_sync()',
    ft = { "go", "gomod" },
    dependencies = {
        { "ray-x/guihua.lua" },
    },
    opts = {},
    config = function(_, opts)
        require("go").setup(opts)
    end,
}
