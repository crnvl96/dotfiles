local n = require('utils.notification')

---@class NvimUtils.Pack
local M = {}

--- Helper for mini.deps helper that wraps common operations on plugins that require a build step.
---@param params table Params for building the plugin
---@param cmd string Cmd to run then building the plugin
---@return nil
function M.build(params, cmd)
  local name, path = params.name, params.path
  local msg = string.format('Building %s', name)
  n.publish(msg .. '...')
  local out = vim.system(vim.split(cmd, ' '), { cwd = path }):wait()
  return out.code == 0 and n.publish(msg .. ' done!') or n.publish(msg .. ' failed', 'ERROR')
end

return M
