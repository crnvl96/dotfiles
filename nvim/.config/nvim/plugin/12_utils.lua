_G.Utils = {}

Utils.Autocmd = vim.api.nvim_create_autocmd
Utils.User = vim.api.nvim_create_user_command

Utils.Keymap = function(desc, opts)
  opts = opts or {}
  opts.desc = desc

  local lhs = ''
  local rhs = ''
  local mode = 'n'

  if opts.mode then
    mode = opts.mode
    opts.mode = nil
  end

  if opts.lhs then
    lhs = opts.lhs
    opts.lhs = nil
  end

  if opts.rhs then
    rhs = opts.rhs
    opts.rhs = nil
  end

  vim.keymap.set(mode, lhs, rhs, opts)
end

Utils.Group = function(name, fn) fn(vim.api.nvim_create_augroup(name, { clear = true })) end

Utils.Log = function(msg, code)
  local lvls = { 'INFO', 'WARN', 'ERROR' }
  local lvl = lvls[code]

  vim.notify(msg, vim.log.levels[lvl])
end

Utils.ReadFromFile = function(filename)
  local filepath = ('%s/%s'):format(vim.fn.stdpath('config'), filename)

  local file = io.open(filepath, 'r')

  if file then
    local key = file:read('*a'):gsub('%s+$', '')
    file:close()

    if not key then
      Utils.Log(('Missing file: %s'):format(filename), 3)
      return nil
    end

    return key
  end

  return nil
end

Utils.SetNodePath = function(node_path)
  if vim.fn.isdirectory(node_path) == 1 then
    vim.env.PATH = node_path .. '/bin:' .. vim.env.PATH
    vim.env.NODE_PATH = node_path

    Utils.Log('Node.js path set to: ' .. node_path, 1)
  else
    Utils.Log('Invalid Node.js path: ' .. node_path, 3)
  end
end

Utils.Build = function(params, cmd)
  local pref = 'Building ' .. params.name
  Utils.Log(pref, 1)

  local obj = vim.system(cmd, { cwd = params.path }):wait()
  local res = obj.code == 0 and (pref .. ' done') or (pref .. ' failed')
  local lvl = obj.code == 0 and 1 or 3

  Utils.Log(res, lvl)
end
