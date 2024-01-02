return {
    'junegunn/fzf', 
    lazy = false,
    build = function()
      vim.fn['fzf#install']()
    end
}
