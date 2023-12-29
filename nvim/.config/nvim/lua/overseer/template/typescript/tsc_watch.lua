return {
    name = "tsc watch",
    builder = function()
        return {
            name = "tsc watch",
            cmd = { "tsc" },
            args = {
                "--watch",
                "tsconfig.build.json",
            },
        }
    end,
    condition = {
        filetype = { "typescript", "json" },
    },
}
