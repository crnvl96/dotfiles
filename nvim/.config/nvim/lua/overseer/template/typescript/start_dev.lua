return {
    name = "npm run start:dev",
    builder = function()
        return {
            name = "npm run start:dev",
            cmd = { "npm" },
            args = {
                "run",
                "start:dev",
            },
        }
    end,
    condition = {
        filetype = { "typescript" },
    },
}
