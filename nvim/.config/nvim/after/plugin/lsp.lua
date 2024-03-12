local methods = vim.lsp.protocol.Methods
local function on_attach(client, bufnr)
	vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "single",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "single",
	})

	local keymaps = {
		{
			method = methods.textDocument_hover,
			cmd = "<leader>k",
			mode = "n",
			desc = "hover",
			fn = vim.lsp.buf.hover,
		},
		{
			method = methods.workspace_diagnostic,
			cmd = "<Leader>cd",
			mode = "n",
			desc = "line diagnostics",
			fn = vim.diagnostic.open_float,
		},
		{
			method = methods.textDocument_signatureHelp,
			cmd = "<C-k>",
			mode = "i",
			desc = "signature help",
			fn = vim.lsp.buf.signature_help,
		},
		{
			method = methods.textDocument_codeAction,
			cmd = "<Leader>ca",
			mode = { "n", "x" },
			desc = "code actions",
			fn = vim.lsp.buf.code_action,
		},
		{
			method = methods.workspace_diagnostic,
			cmd = "<Leader>sd",
			mode = "n",
			desc = "diagnostics",
			fn = vim.diagnostic.setqflist,
		},
		{
			method = methods.textDocument_definition,
			cmd = "gd",
			mode = "n",
			desc = "go to definition",
			fn = vim.lsp.buf.definition,
		},
		{
			method = methods.textDocument_references,
			cmd = "gr",
			mode = "n",
			desc = "go to references",
			fn = vim.lsp.buf.references,
		},
		{
			method = methods.textDocument_declaration,
			cmd = "gD",
			mode = "n",
			desc = "go to declaration",
			fn = vim.lsp.buf.declaration,
		},
		{
			method = methods.textDocument_typedefinition,
			cmd = "gy",
			mode = "n",
			desc = "go to t[y]pedef",
			fn = vim.lsp.buf.type_definition,
		},
		{
			method = methods.textDocument_implementation,
			cmd = "gi",
			mode = "n",
			desc = "go to implementations",
			fn = vim.lsp.buf.implementation,
		},
	}

	for _, keymap in ipairs(keymaps) do
		if client.supports_method(keymap.method) then
			vim.keymap.set(keymap.mode, keymap.cmd, keymap.fn, { buffer = bufnr, desc = keymap.desc })
		end
	end

	if client.supports_method(methods.textDocument_formatting) then
		vim.keymap.set("n", "<Leader><space>", function()
			vim.lsp.buf.format({
				async = false,
				id = client.id,
				name = client.name,
				bufnr = bufnr,
				timeout_ms = 2000,
			})
		end, { silent = true, desc = "format bufnr" })
	end
end

local capabilities = vim.tbl_deep_extend(
	"force",
	vim.lsp.protocol.make_client_capabilities(),
	require("ddc_source_lsp").make_client_capabilities(),
	{
		workspace = {
			-- PERF: didChangeWatchedFiles is too slow.
			-- TODO: Remove this when https://github.com/neovim/neovim/issues/23291#issuecomment-1686709265 is fixed.
			didChangeWatchedFiles = { dynamicRegistration = false },
		},
	}
)

require("lspconfig.ui.windows").default_options = {
	border = "single",
}

require("mason").setup({
	ensure_installed = {
		"gofumpt", -- go
		"prettier", -- javascript
		"stylua",
	},
})

require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"jsonls",
		"vimls",
		"tsserver",
		"pyright",
		"bashls",
		"gopls",
		"denols",
		"eslint",
	},
	handlers = {
		bashls = function()
			require("lspconfig").bashls.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					on_attach(client, bufnr)
				end,
			})
		end,
		jsonls = function()
			require("lspconfig").bashls.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					if client.name == "jsonls" then
						client.capabilities.documentFormattingProvider = false
					end
					on_attach(client, bufnr)
				end,
			})
		end,
		vimls = function()
			require("lspconfig").vimls.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					on_attach(client, bufnr)
				end,
			})
		end,
		pyright = function()
			require("lspconfig").pyright.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					on_attach(client, bufnr)
				end,
			})
		end,
		tsserver = function()
			require("lspconfig").tsserver.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					if client.name == "tsserver" then
						client.server_capabilities.documentFormattingProvider = true
						client.server_capabilities.documentFormattingRangeProvider = true
					end
					on_attach(client, bufnr)
				end,
			})
		end,
		eslint = function()
			require("lspconfig").eslint.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					if client.name == "eslint" then
						client.server_capabilities.documentFormattingProvider = true
						client.server_capabilities.documentFormattingRangeProvider = true
					end
					on_attach(client, bufnr)
				end,
				settings = {
					eslint = {
						format = { enable = true },
						lint = { enable = true },
						workingDirectories = {
							mode = "auto",
						},
					},
				},
			})
		end,
		gopls = function()
			require("lspconfig").gopls.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					on_attach(client, bufnr)
				end,
				settings = {
					gopls = {
						gofumpt = true,
					},
				},
			})
		end,
		lua_ls = function()
			local runtime_path = vim.split(package.path, ";")
			table.insert(runtime_path, "lua/?.lua")
			table.insert(runtime_path, "lua/?/init.lua")
			require("lspconfig").lua_ls.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					on_attach(client, bufnr)
				end,
				settings = {
					Lua = {
						telemetry = { enable = false },
						runtime = {
							version = "LuaJIT",
							path = runtime_path,
						},
						format = {
							enable = false,
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							checkThirdParty = false,
							library = {
								vim.fn.expand("$VIMRUNTIME/lua"),
								vim.fn.stdpath("config") .. "/lua",
							},
						},
					},
				},
			})
		end,
	},
})

vim.diagnostic.config({
	virtual_text = {
		prefix = "",
		spacing = 2,
		format = function(diagnostic)
			local message = vim.split(diagnostic.message, "\n")[1]
			return string.format("%s", message)
		end,
	},
	float = {
		border = "single",
	},
	signs = false,
})

local register_capability = vim.lsp.handlers[methods.client_registerCapability]
vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
	local client = vim.lsp.get_client_by_id(ctx.client_id)
	if not client then
		return
	end
	on_attach(client, vim.api.nvim_get_current_buf())
	return register_capability(err, res, ctx)
end
