local n = require('utils.notification')

local node_version =
  vim.fn.system("mise ls --cd ~ | grep '^node' | grep '22\\.' | head -n 1 | awk '{print $2}'"):gsub('\n', '')

if node_version == '' then
  n.publish('Could not determine Node.js version from mise.', 'WARN')
else
  local default_nodejs = os.getenv('HOME') .. '/.local/share/mise/installs/node/' .. node_version .. '/bin/'
  vim.g.node_host_prog = default_nodejs .. 'node'
  vim.env.PATH = default_nodejs .. ':' .. vim.env.PATH
end
