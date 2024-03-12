vim.api.nvim_create_user_command("GoDapDebugNearestTest", function()
	require("dap-go").debug_test()
end, { desc = "debug nearest go test", nargs = 0 })
