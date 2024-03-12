local ok = pcall(require, "nvim-treesitter.configs")
if ok then
	require("nvim-treesitter.configs").setup({
		ensure_installed = { "bash", "c", "lua", "vim", "vimdoc", "query" },
		auto_install = true,
		highlight = {
			enable = true,
			disable = function(_, buf)
				local max_filesize = 100 * 1024 -- 100 KB
				---@diagnostic disable-next-line: undefined-field
				local done, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				if done and stats and stats.size > max_filesize then
					return true
				end
			end,
			additional_vim_regex_highlighting = false,
		},
	})
end
