MiniDeps.now(function()
  MiniDeps.add({ name = 'mini.nvim' })
  MiniDeps.add('nvim-lua/plenary.nvim')
  MiniDeps.add('neovim/nvim-lspconfig')
  MiniDeps.add('tpope/vim-fugitive')
  MiniDeps.add('tpope/vim-rhubarb')
  MiniDeps.add('tpope/vim-sleuth')
  MiniDeps.add('mbbill/undotree')
end)

-- MiniDeps.later(function()
--   vim.cmd('set rtp+=~/Developer/personal/lazydocker.nvim/')
--   require('lazydocker').setup({
--     window = {
--       settings = {
--         width = 0.9,
--         height = 0.9,
--       },
--     },
--   })
--   vim.keymap.set({ 'n', 't' }, '<leader>zz', '<Cmd>lua LazyDocker.toggle()<CR>')
--   vim.keymap.set({ 'n', 't' }, '<leader>zp', "<Cmd>lua LazyDocker.toggle({engine='podman'})<CR>")
-- end)
