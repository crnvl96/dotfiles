local methods = vim.lsp.protocol.Methods

local ok = pcall(require, "fzf-lua")
if ok then
	local function on_attach(client, bufnr)
		if client.name == "eslint" then
			client.server_capabilities.documentFormattingProvider = true
		end

		if client.name == "tsserver" then
			client.server_capabilities.documentFormattingProvider = false
		end

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

		-- stylua: ignore start
		-- vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })
		local keymaps = {
			{ method = methods.textDocument_hover, cmd = "<leader>k", mode = "n", desc = "hover", fn = vim.lsp.buf.hover },
			{ method = methods.workspace_diagnostic, cmd = "<Leader>cd", mode = "n", desc = "line diagnostics", fn = vim.diagnostic.open_float },
			{ method = methods.textDocument_signatureHelp, cmd = "<C-k>", mode = "i", desc = "signature help", fn = vim.lsp.buf.signature_help },
			{ method = methods.textDocument_hover, cmd = "<leader>k", mode = "n", desc = "hover", fn = vim.lsp.buf.hover },
			{ method = methods.workspace_diagnostic, cmd = "<Leader>cd", mode = "n", desc = "line diagnostics", fn = vim.diagnostic.open_float },
			{ method = methods.textDocument_signatureHelp, cmd = "<C-k>", mode = "i", desc = "signature help", fn = vim.lsp.buf.signature_help },
			{ method = methods.textDocument_documentSymbol, cmd = "<leader>fs", mode = "n", desc = "document symbols", fn = require("fzf-lua").lsp_document_symbols },
			{ method = methods.textDocument_codeAction, cmd = "<Leader>ca", mode = { "n", "x" }, desc = "code actions", fn = vim.lsp.buf.code_action },
			{ method = methods.workspace_diagnostic, cmd = "<Leader>fd", mode = "n", desc = "diagnostics", fn = require("fzf-lua").diagnostics_document },
			{ method = methods.textDocument_definition, cmd = "gd", mode = "n", desc = "go to definition", fn = function() require("fzf-lua").lsp_definitions({ jump_to_single_result = true }) end },
			{ method = methods.textDocument_references, cmd = "gr", mode = "n", desc = "go to references", fn = function() require("fzf-lua").lsp_references({ jump_to_single_result = true, ignore_current_line = true }) end },
			{ method = methods.textDocument_declaration, cmd = "gD", mode = "n", desc = "go to declaration", fn = require("fzf-lua").lsp_declarations },
			{ method = methods.textDocument_typedefinition, cmd = "gy", mode = "n", desc = "go to t[y]pedef", fn = require("fzf-lua").lsp_typedefs },
			{ method = methods.textDocument_implementation, cmd = "gi", mode = "n", desc = "go to implementations", fn = require("fzf-lua").lsp_implementations },
		}
		-- stylua: ignore end

		for _, keymap in ipairs(keymaps) do
			if client.supports_method(keymap.method) then
				vim.keymap.set(keymap.mode, keymap.cmd, keymap.fn, { buffer = bufnr, desc = keymap.desc })
			end
		end

		local function keymap(lhs, rhs, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
		end

		keymap("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
		keymap("]d", vim.diagnostic.goto_next, "Next diagnostic")
		keymap("[e", function()
			vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
		end, "Previous error")
		keymap("]e", function()
			vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
		end, "Next error")
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
end
