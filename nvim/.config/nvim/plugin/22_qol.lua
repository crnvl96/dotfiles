Add('nvim-lua/plenary.nvim')
Add('tpope/vim-fugitive')
Add('danymat/neogen')
Add('MagicDuck/grug-far.nvim')
Add('folke/which-key.nvim')
Add('sainnhe/gruvbox-material')
Add('andymass/vim-matchup')
Add('ggandor/flit.nvim')
Add('ggandor/leap.nvim')
Add('tpope/vim-repeat')

require('leap').add_default_mappings(true)

require('flit').setup({ labeled_modes = 'nx' })

require('grug-far').setup({
    headerMaxWidth = 80,
})

vim.cmd([[
    let g:gruvbox_material_enable_bold = 1
    let g:gruvbox_material_enable_italic = 0
    let g:gruvbox_material_better_performance = 1

    colorscheme gruvbox-material
]])

require('neogen').setup({
    snippet_engine = 'mini',
    languages = {
        lua = { template = { annotation_convention = 'emmylua' } },
        python = { template = { annotation_convention = 'numpydoc' } },
    },
})

require('which-key').setup({
    preset = 'helix',
    delay = function(ctx) return ctx.plugin and 0 or 200 end,
    triggers = {
        { '<auto>', mode = 'nxso' },
    },
    win = {
        border = 'none',
        padding = { 1, 2 },
        title = false,
    },
    icons = { mappings = false },
    show_help = false,
    show_keys = false,
})
