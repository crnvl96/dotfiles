local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_capabilities = {}

local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')

if ok then cmp_capabilities = cmp_nvim_lsp.default_capabilities() end

return vim.tbl_deep_extend('force', {}, lsp_capabilities, cmp_capabilities)
