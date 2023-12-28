return {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    init = function()
        vim.opt.background = "dark"
        vim.g.gruvbox_material_background = "hard"
        vim.g.gruvbox_material_enable_bold = 1
        vim.g.gruvbox_material_enable_italic = 1
        vim.g.gruvbox_material_sign_column_background = "grey"
        vim.g.gruvbox_material_spell_foreground = "colored"
        vim.g.gruvbox_material_diagnostic_text_highlight = 1
        vim.g.gruvbox_material_diagnostic_line_highlight = 1
        vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
        vim.g.gruvbox_material_current_word = "underline"
        vim.g.gruvbox_material_better_performance = 1

        vim.cmd.colorscheme("gruvbox-material")
    end,
}
