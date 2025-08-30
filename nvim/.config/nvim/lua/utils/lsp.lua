---@class NvimUtils.Lsp
local M = {}

function M.set_global_config()
  vim.lsp.config('*', {
    capabilities = vim.tbl_deep_extend(
      'force',
      vim.lsp.protocol.make_client_capabilities(),
      { general = { positionEncodings = { 'utf-16' } } }
    ),
  })
end

function M.enable_allowed_servers()
  local servers = {
    all = vim.fn.glob(os.getenv('HOME') .. '/.config/nvim/lsp/*.lua', true, true),
    allowed = {},
    prohibited = { 'rust_analyzed' },
  }

  for _, file in ipairs(servers.all) do
    local server_name = vim.fn.fnamemodify(file, ':t:r')
    local is_server_allowed = not vim.tbl_contains(servers.prohibited, server_name)

    if is_server_allowed then
      table.insert(servers.allowed, server_name)
      local content = assert(loadfile(file))
      vim.lsp.config(server_name, content())
    end
  end

  vim.lsp.enable(servers.allowed)
end

return M
