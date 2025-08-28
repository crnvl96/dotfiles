require('grug-far').setup({ transient = true })

local function toggle_grug(prefills)
  require('grug-far').toggle_instance({
    instanceName = 'far',
    staticTitle = 'Find and Replace',
    prefills = prefills or {},
  })
end

vim.keymap.set({ 'n', 'i' }, '<C-3>', function() toggle_grug() end, { desc = 'Live grep' })

vim.keymap.set(
  { 'n', 'i' },
  '<C-2>',
  function() toggle_grug({ paths = vim.fn.expand('%') }) end,
  { desc = 'Buffer lines' }
)
