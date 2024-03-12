vim.diagnostic.config({
	virtual_text = false,
	float = { border = "single" },
	signs = true,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()

local ok

ok = pcall(require, "cmp_nvim_lsp")
if ok then
	capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
end

ok = pcall(require, "mason")
if ok then
	require("mason").setup({
		ensure_installed = {
			"prettier", -- javascript
			"prettier_d",
			"eslint_d",
			"gofumpt",
			"goimports",
			"golines",
			"stylua",
		},
	})
end

local mlsp = pcall(require, "mason-lspconfig")
local lsp = pcall(require, "lspconfig")
if mlsp and lsp then
	require("lspconfig.ui.windows").default_options = { border = "single" }
	require("mason-lspconfig").setup({
		ensure_installed = {
			"lua_ls",
			"jsonls",
			"vimls",
			"pyright",
			"bashls",
			"tsserver",
			"gopls",
			"denols",
		},
	})

	require("mason-lspconfig").setup_handlers({
		function(server)
			require("lspconfig")[server].setup({
				capabilities = capabilities,
			})
		end,
		["denols"] = function() end,
		["lua_ls"] = function()
			local runtime_path = vim.split(package.path, ";")
			table.insert(runtime_path, "lua/?.lua")
			table.insert(runtime_path, "lua/?/init.lua")
			require("lspconfig").lua_ls.setup({
				capabilities = capabilities,
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
	})
end
