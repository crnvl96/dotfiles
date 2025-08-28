-- Variables ================================================================

_G.HOME = os.getenv('HOME') -- Home directory
_G.NVIM_DIR = HOME .. '/.config/nvim' -- Nvim config directory
_G.MINI_PATH = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim' -- Mini.deps default directory

-- A small helper for retrieving env vars ================================================================

function _G.RetrieveFromEnv(key_name)
  local filepath = NVIM_DIR .. '/.env'
  local file = io.open(filepath, 'r')

  if not file then return nil end

  for line in file:lines() do
    line = line:match('^%s*(.-)%s*$')

    if line ~= '' and not line:match('^#') then
      local eq_pos = line:find('=')
      if eq_pos then
        local current_key = line:sub(1, eq_pos - 1)
        local current_value = line:sub(eq_pos + 1)

        current_key = current_key:match('^%s*(.-)%s*$')
        current_value = current_value:match('^%s*(.-)%s*$')

        if current_key == key_name then
          file:close()
          return current_value
        end
      end
    end
  end

  file:close()

  return nil
end

-- A small helper for some plugins that require building ================================================================

function _G.Build(params, cmd)
  cmd = cmd or 'cargo +nightly build --release'
  vim.notify('Building ' .. params.name, vim.log.levels.INFO)
  local out = vim.system(vim.split(cmd, ' '), { cwd = params.path }):wait()
  if out.code == 0 then return vim.notify('Building ' .. params.name .. ' done', vim.log.levels.INFO) end
  return vim.notify('Building ' .. params.name .. ' failed', vim.log.levels.ERROR)
end

-- A small helper for HLs ================================================================

function _G.CustomHL(hl_name, opts)
  local is_ok, hl_def = pcall(vim.api.nvim_get_hl_by_name, hl_name, true)
  if is_ok then
    for k, v in pairs(opts) do
      hl_def[k] = v
    end
    vim.api.nvim_set_hl(0, hl_name, hl_def)
  end
end
