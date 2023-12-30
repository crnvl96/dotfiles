return {
    name = "Run File",
    builder = function()
        local file = vim.fn.expand("%:p")
        local cmd = { file }
        if vim.bo.filetype == "go" then
            cmd = { "go", "run", file }
        end
        return {
            cmd = cmd,
        }
    end,
    condition = {
        filetype = { "go" },
    },
}
