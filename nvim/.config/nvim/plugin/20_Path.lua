-- Path ================================================================
-- Command to find the current node version (v22.x is the lts) installed by mise
-- Tracking about versions can be found at https://nodejs.org/en/about/previous-releases
-- This is needed to avoid nvim reading a wrong node version due to a project setting it at its root folder

local node_version =
  vim.fn.system("mise ls --cd ~ | grep '^node' | grep '22\\.' | head -n 1 | awk '{print $2}'"):gsub('\n', '')

if node_version == '' then
  vim.notify(
    'Could not determine Node.js version from mise. Please ensure mise is installed and a Node.js version is set.',
    vim.log.levels.WARN
  )
else
  local default_nodejs = HOME .. '/.local/share/mise/installs/node/' .. node_version .. '/bin/'
  vim.g.node_host_prog = default_nodejs .. 'node'
  vim.env.PATH = default_nodejs .. ':' .. vim.env.PATH
end
