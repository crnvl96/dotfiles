local ok = pcall(require, "conform")
if ok then
	vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	local slow_format_filetypes = {}
	require("conform").setup({
		format_on_save = function(bufnr)
			if slow_format_filetypes[vim.bo[bufnr].filetype] then
				return
			end
			local function on_format(err)
				if err and err:match("timeout$") then
					slow_format_filetypes[vim.bo[bufnr].filetype] = true
				end
			end

			return { timeout_ms = 200, lsp_fallback = true }, on_format
		end,
		format_after_save = function(bufnr)
			if not slow_format_filetypes[vim.bo[bufnr].filetype] then
				return
			end
			return { lsp_fallback = true }
		end,
		notify_on_error = false,
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
			go = { "gofumpt", "goimports", "golines" },
			["_"] = { "trim_whitespace" },
		},
	})
end
