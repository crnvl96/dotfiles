MiniDeps.later(function()
  local miniclue = require('mini.clue')

  -- Some builtin keymaps that I don't use and that I don't want mini.clue to show.
  for _, lhs in ipairs({ '[%', ']%', 'g%' }) do
    vim.keymap.del('n', lhs)
  end

  -- Add a-z/A-Z marks.
  local function mark_clues()
    local marks = {}
    vim.list_extend(marks, vim.fn.getmarklist(vim.api.nvim_get_current_buf()))
    vim.list_extend(marks, vim.fn.getmarklist())

    return vim
      .iter(marks)
      :map(function(mark)
        local key = mark.mark:sub(2, 2)

        -- Just look at letter marks.
        if not string.match(key, '^%a') then return nil end

        -- For global marks, use the file as a description.
        -- For local marks, use the line number and content.
        local desc
        if mark.file then
          desc = vim.fn.fnamemodify(mark.file, ':p:~:.')
        elseif mark.pos[1] and mark.pos[1] ~= 0 then
          local line_num = mark.pos[2]
          local lines = vim.fn.getbufline(mark.pos[1], line_num)
          if lines and lines[1] then desc = string.format('%d: %s', line_num, lines[1]:gsub('^%s*', '')) end
        end

        if desc then return { mode = 'n', keys = string.format('`%s', key), desc = desc } end
      end)
      :totable()
  end

  -- Clues for recorded macros.
  local function macro_clues()
    local res = {}
    for _, register in ipairs(vim.split('abcdefghijklmnopqrstuvwxyz', '')) do
      local keys = string.format('"%s', register)
      local ok, desc = pcall(vim.fn.getreg, register)
      if ok and desc ~= '' then
        ---@cast desc string
        desc = string.format('register: %s', desc:gsub('%s+', ' '))
        table.insert(res, { mode = 'n', keys = keys, desc = desc })
        table.insert(res, { mode = 'v', keys = keys, desc = desc })
      end
    end

    return res
  end

  require('mini.clue').setup({
    triggers = {
      -- Builtins.
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = '`' },
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' },
      { mode = 'i', keys = '<C-x>' },
      { mode = 'n', keys = 'z' },
      -- Leader triggers.
      { mode = 'n', keys = '<leader>' },
      { mode = 'x', keys = '<leader>' },
      -- Moving between stuff.
      { mode = 'n', keys = '[' },
      { mode = 'n', keys = ']' },
    },
    clues = {
      -- Leader/movement groups.
      { mode = 'n', keys = '<leader>f', desc = '+find' },
      { mode = 'x', keys = '<leader>f', desc = '+find' },
      { mode = 'n', keys = '[', desc = '+prev' },
      { mode = 'n', keys = ']', desc = '+next' },
      -- Builtins.
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
      -- Custom extras.
      mark_clues,
      macro_clues,
    },
    window = {
      delay = 500,
      scroll_down = '<C-f>',
      scroll_up = '<C-b>',
      config = function()
        return {
          width = 'auto',
        }
      end,
    },
  })
end)
