---@class NvimUtils.Fmt
local M = {}

function M.evaluate_fmt(root_marker, target, fallback)
  local util = require('conform.util')
  return util.root_file(root_marker) and target or fallback
end

function M.get_web_fmt()
  return M.evaluate_fmt(
    { 'biome.json', 'biome.jsonc' },
    { 'biome', 'biome-check', 'biome-organize-imports' },
    { 'prettier' }
  )
end

return M
