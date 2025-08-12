MiniDeps.later(function()
  MiniDeps.add('MagicDuck/grug-far.nvim')

  require('grug-far').setup({
    transient = true,
    keymaps = {
      replace = { n = '<localleader>r' },
      qflist = { n = '<localleader>q' },
      syncLocations = { n = '<localleader>s' },
      syncLine = { n = '<localleader>l' },
      close = { n = '<localleader>c' },
      historyOpen = { n = '<localleader>t' },
      historyAdd = { n = '<localleader>a' },
      refresh = { n = '<localleader>f' },
      openLocation = { n = '<localleader>o' },
      openNextLocation = { n = '<C-j>' },
      openPrevLocation = { n = '<C-k>' },
      gotoLocation = { n = '<enter>' },
      pickHistoryEntry = { n = '<enter>' },
      abort = { n = '<localleader>b' },
      help = { n = 'g?' },
      toggleShowCommand = { n = '<localleader>w' },
      swapEngine = { n = '<localleader>e' },
      previewLocation = { n = '<localleader>i' },
      swapReplacementInterpreter = { n = '<localleader>x' },
      applyNext = { n = '<localleader>j' },
      applyPrev = { n = '<localleader>k' },
      syncNext = { n = '<localleader>n' },
      syncPrev = { n = '<localleader>p' },
      syncFile = { n = '<localleader>v' },
      nextInput = { n = '<tab>' },
      prevInput = { n = '<s-tab>' },
    },
  })

  vim.keymap.set('n', '<Leader>g', '<Cmd>GrugFar<CR>', { desc = 'Live grep' })

  vim.keymap.set(
    'n',
    '<Leader>l',
    function() require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } }) end,
    { desc = 'Find lines' }
  )
end)
