local methods = vim.lsp.protocol.Methods
local function on_attach(client, bufnr)
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = vim.api.nvim_create_augroup(vim.g.whoami .. "/lsp_autoformat", { clear = true }),
		callback = function()
			local config = {
				async = false,
				id = client.id,
				name = client.name,
				bufnr = bufnr,
				timeout_ms = 2000,
			}
			vim.lsp.buf.format(config)
		end,
	})

	if client.name == "eslint" then
		client.server_capabilities.documentFormattingProvider = true
	end

	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
	end

	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*.go",
		callback = function()
			local params = vim.lsp.util.make_range_params()
			params.context = { only = { "source.organizeImports" } }
			-- buf_request_sync defaults to a 1000ms timeout. Depending on your
			-- machine and codebase, you may want longer. Add an additional
			-- argument after params if you find that you have to write the file
			-- twice for changes to be saved.
			-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
			local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
			for cid, res in pairs(result or {}) do
				for _, r in pairs(res.result or {}) do
					if r.edit then
						local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
						vim.lsp.util.apply_workspace_edit(r.edit, enc)
					end
				end
			end
			vim.lsp.buf.format({ async = false })
		end,
	})

	vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
	vim.lsp.handlers["textDocument/signatureHelp"] =
		vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })

	if client.supports_method(methods.textDocument_hover) then
		vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, { desc = "hover", buffer = bufnr })
	end

	if client.supports_method(methods.workspace_diagnostic) then
		vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "line diagnostic", buffer = bufnr })
	end

	if client.supports_method(methods.textDocument_signatureHelp) then
		vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "signature help", buffer = bufnr })
	end

	if client.supports_method(methods.workspace_diagnostic) then
		vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "signature help", buffer = bufnr })
	end

	if client.supports_method(methods.textDocument_documentSymbol) then
		vim.keymap.set("n", "<leader>fs", function()
			vim.fn["ddu#start"]({
				sources = {
					{ name = "lsp_documentSymbol" },
				},
				sourceOptions = {
					lsp = {
						volatile = true,
					},
				},
			})
		end, { desc = "hover", buffer = bufnr })
	end

	if client.supports_method(methods.textDocument_codeAction) then
		vim.keymap.set({ "n", "x" }, "<leader>ca", function()
			vim.fn["ddu#start"]({
				sources = {
					{ name = "lsp_codeAction" },
				},
				sourceOptions = {
					lsp = {
						volatile = true,
					},
				},
			})
		end, { desc = "code actions", buffer = bufnr })
	end

	if client.supports_method(methods.workspace_diagnostic) then
		vim.keymap.set("n", "<leader>fd", function()
			vim.fn["ddu#start"]({
				sources = {
					{
						name = "lsp_diagnostic",
						params = {
							buffer = 0,
						},
					},
				},
				sourceOptions = {
					lsp = {
						volatile = true,
					},
				},
			})
		end, { desc = "buffer diagnostics", buffer = bufnr })
	end

	if client.supports_method(methods.textDocument_definition) then
		vim.keymap.set("n", "gd", function()
			vim.fn["ddu#start"]({
				sources = {
					{
						name = "lsp_definition",
						params = {
							method = "textDocument/definition",
						},
					},
				},
				sourceOptions = {
					lsp = {
						volatile = true,
					},
				},
			})
		end, { desc = "goto definition", buffer = bufnr })
	end

	if client.supports_method(methods.textDocument_references) then
		vim.keymap.set("n", "gr", function()
			vim.fn["ddu#start"]({
				sources = {
					{ name = "lsp_references" },
				},
				sourceOptions = {
					lsp = {
						volatile = true,
					},
				},
			})
		end, { desc = "goto references", buffer = bufnr })
	end

	if client.supports_method(methods.textDocument_declaration) then
		vim.keymap.set("n", "gD", function()
			vim.fn["ddu#start"]({
				sources = {
					{
						name = "lsp_definition",
						params = {
							method = "textDocument/declaration",
						},
					},
				},
				sourceOptions = {
					lsp = {
						volatile = true,
					},
				},
			})
		end, { desc = "goto declaration", buffer = bufnr })
	end

	if client.supports_method(methods.textDocument_typeDefinition) then
		vim.keymap.set("n", "gy", function()
			vim.fn["ddu#start"]({
				sources = {
					{
						name = "lsp_definition",
						params = {
							method = "textDocument/typeDefinition",
						},
					},
				},
				sourceOptions = {
					lsp = {
						volatile = true,
					},
				},
			})
		end, { desc = "goto typedef", buffer = bufnr })
	end

	if client.supports_method(methods.textDocument_implementation) then
		vim.keymap.set("n", "gi", function()
			vim.fn["ddu#start"]({
				sources = {
					{
						name = "lsp_definition",
						params = {
							method = "textDocument/implementation",
						},
					},
				},
				sourceOptions = {
					lsp = {
						volatile = true,
					},
				},
			})
		end, { desc = "goto implementation", buffer = bufnr })
	end

	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "prev diagnostic" })
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "next diagnostic" })
	vim.keymap.set("n", "[e", function()
		vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
	end, { buffer = bufnr, desc = "prev error" })
	vim.keymap.set("n", "]e", function()
		vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
	end, { buffer = bufnr, desc = "next error" })
end

local register_capability = vim.lsp.handlers[methods.client_registerCapability]
vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
	local client = vim.lsp.get_client_by_id(ctx.client_id)
	if not client then
		return
	end
	on_attach(client, vim.api.nvim_get_current_buf())
	return register_capability(err, res, ctx)
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup(vim.g.whoami .. "/fzf-lua-lsp", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local bufnr = args.buf
		on_attach(client, bufnr)
	end,
})
