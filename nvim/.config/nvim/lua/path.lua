local node_version = vim.fn
  .system("mise ls --cd ~ | grep '^node' | grep '22\\.' | head -n 1 | awk '{print $2}'")
  :gsub('\n', '')

if node_version == '' then
  vim.notify(
    'Could not determine Node.js version from mise. Please ensure mise is installed and a Node.js version is set.',
    vim.log.levels.WARN
  )
else
  local default_nodejs = HOME
    .. '/.local/share/mise/installs/node/'
    .. node_version
    .. '/bin/'
  vim.g.node_host_prog = default_nodejs .. 'node'
  vim.env.PATH = default_nodejs .. ':' .. vim.env.PATH
end
