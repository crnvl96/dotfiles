vim.keymap.set("n", "<leader>fb", function()
	vim.fn["ddu#start"]({
		sources = {
			{ name = "buffer" },
		},
	})
end, { desc = "buffer" })

vim.keymap.set("n", "<leader>fl", function()
	vim.fn["ddu#start"]({
		sources = {
			{ name = "line" },
		},
	})
end, { desc = "lines" })

vim.keymap.set("n", "<leader>ff", function()
	vim.fn["ddu#start"]({
		sources = {
			{
				name = "file_external",
				options = {
					converters = { "converter_devicon" },
				},
				params = {
					cmd = vim.fn.split("fd -t f -t l -H -L --color never", " "),
				},
			},
		},
	})
end, { desc = "files" })

vim.keymap.set("n", "<leader>fg", function()
	vim.fn["ddu#start"]({
		sources = {
			{
				name = "rg",
				options = {
					matchers = {},
					volatile = true,
					converters = { "converter_devicon" },
					path = vim.fn.getcwd(),
				},
				params = {
					args = { "--json" },
				},
			},
		},
	})
end, { desc = "rg" })
