Add('olimorris/codecompanion.nvim')

local K = Utils.Keymap

-- https://github.com/olimorris/codecompanion.nvim/tree/main/lua/codecompanion/adapters
vim.g.codecompanion_adapter = 'huggingface'

local progress = require('fidget.progress')

local M = {}

function M:init()
  local group = vim.api.nvim_create_augroup('CodeCompanionFidgetHooks', {})

  vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'CodeCompanionRequestStarted',
    group = group,
    callback = function(request)
      local handle = M:create_progress_handle(request)
      M:store_progress_handle(request.data.id, handle)
    end,
  })

  vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'CodeCompanionRequestFinished',
    group = group,
    callback = function(request)
      local handle = M:pop_progress_handle(request.data.id)
      if handle then
        M:report_exit_status(handle, request)
        handle:finish()
      end
    end,
  })
end

M.handles = {}

function M:store_progress_handle(id, handle) M.handles[id] = handle end

function M:pop_progress_handle(id)
  local handle = M.handles[id]
  M.handles[id] = nil
  return handle
end

function M:create_progress_handle(request)
  return progress.handle.create({
    title = ' Requesting assistance (' .. request.data.strategy .. ')',
    message = 'In progress...',
    lsp_client = {
      name = M:llm_role_title(request.data.adapter),
    },
  })
end

function M:llm_role_title(adapter)
  local parts = {}
  table.insert(parts, adapter.formatted_name)
  if adapter.model and adapter.model ~= '' then table.insert(parts, '(' .. adapter.model .. ')') end
  return table.concat(parts, ' ')
end

function M:report_exit_status(handle, request)
  if request.data.status == 'success' then
    handle.message = 'Completed'
  elseif request.data.status == 'error' then
    handle.message = ' Error'
  else
    handle.message = '󰜺 Cancelled'
  end
end

M:init()

require('codecompanion').setup({
  strategies = {
    chat = {
      adapter = vim.g.codecompanion_adapter,
      keymaps = {
        completion = {
          modes = {
            i = '<C-n>',
          },
        },
      },
    },
    inline = { adapter = vim.g.codecompanion_adapter },
    cmd = { adapter = vim.g.codecompanion_adapter },
  },
  display = {
    chat = {
      window = {
        layout = 'buffer',
      },
    },
  },
  adapters = {
    huggingface = require('codecompanion.adapters').extend('huggingface', {
      env = { api_key = Utils.ReadFromFile('huggingface') },
      schema = {
        model = {
          -- available models can be found at https://huggingface.co/models?inference=warm&pipeline_tag=text-generation
          -- https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/adapters/huggingface.lua
          default = 'deepseek-ai/DeepSeek-R1-Distill-Qwen-32B',
        },
      },
    }),
    anthropic = require('codecompanion.adapters').extend('anthropic', {
      env = { api_key = Utils.ReadFromFile('anthropic') },
      schema = {
        model = {
          -- https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/adapters/anthropic.lua
          default = 'claude-3-5-haiku-20241022',
        },
      },
    }),
    deepseek = require('codecompanion.adapters').extend('deepseek', {
      env = { api_key = Utils.ReadFromFile('deepseek') },
      schema = {
        model = {
          -- https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/adapters/deepseek.lua
          default = 'deepseek-chat',
        },
      },
    }),
  },
})

K('Actions', { lhs = '<Leader>ca', mode = { 'n', 'v' }, rhs = '<Cmd>CodeCompanionActions<CR>' })
K('Toggle', { lhs = '<Leader>ct', mode = { 'n', 'v' }, rhs = '<Cmd>CodeCompanionChat Toggle<CR>' })
K('Chat', { lhs = '<Leader>cc', mode = 'v', rhs = ':CodeCompanionChat Add<CR>' })
