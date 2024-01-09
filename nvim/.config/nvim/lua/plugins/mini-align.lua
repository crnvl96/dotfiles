return {
    "echasnovski/mini.align",
    event = "VeryLazy",
    opts = {
        mappings = {
            start = "ga",
            start_with_preview = "gA",
        },
        options = {
            split_pattern = "",
            justify_side = "left",
            merge_delimiter = "",
        },
        steps = {
            pre_split = {},
            split = nil,
            pre_justify = {},
            justify = nil,
            pre_merge = {},
            merge = nil,
        },
        silent = false,
    },
    config = function(_, opts)
        require("mini.align").setup(opts)
    end,
}
