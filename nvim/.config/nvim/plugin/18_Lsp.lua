local lsp_dir = NVIM_DIR .. '/lsp'
local excluded_servers = { 'rust_analyzer' }
local lsp_servers = {}

local function default_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  capabilities = vim.tbl_deep_extend('force', capabilities, {
    general = {
      positionEncodings = { 'utf-16' },
    },
  })

  return capabilities
end

vim.lsp.config('*', {
  capabilities = default_capabilities(),
})

for _, file in ipairs(vim.fn.glob(lsp_dir .. '/*.lua', true, true)) do
  local server_name = vim.fn.fnamemodify(file, ':t:r')
  if not vim.tbl_contains(excluded_servers, server_name) then
    table.insert(lsp_servers, server_name)
    local chunk = assert(loadfile(file))
    vim.lsp.config(server_name, chunk())
  end
end

vim.lsp.enable(lsp_servers)
