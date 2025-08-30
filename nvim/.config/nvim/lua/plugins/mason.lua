local c = require('utils.constants')

require('mason').setup()

require('mason-registry').refresh(function()
  for _, tool in ipairs(c.mason_tools) do
    local p = require('mason-registry').get_package(tool)
    if not p:is_installed() then p:install() end
  end
end)
