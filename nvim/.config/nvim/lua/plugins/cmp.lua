return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "L3MON4D3/LuaSnip" },
            {
                "windwp/nvim-autopairs",
                event = "InsertEnter",
                opts = {
                    enable_check_bracket_line = false,
                    ignored_next_char = "[%w%.]",
                },
                config = function(_, opts)
                    require("nvim-autopairs").setup(opts)
                    local function rule(a1, ins, a2, lang)
                        require("nvim-autopairs").add_rule(require("nvim-autopairs.rule")(ins, ins, lang)
                            :with_pair(function(options)
                                return a1 .. a2 == options.line:sub(options.col - #a1, options.col + #a2 - 1)
                            end)
                            :with_move(require("nvim-autopairs.conds").none())
                            :with_cr(require("nvim-autopairs.conds").none())
                            :with_del(function(options)
                                local col = vim.api.nvim_win_get_cursor(0)[2]
                                return a1 .. ins .. ins .. a2 == options.line:sub(col - #a1 - #ins + 1, col + #ins + #a2) -- insert only works for #ins == 1 anyway
                            end))
                    end

                    rule("(", " ", ")")
                    rule("[", " ", "]")
                    rule("{", " ", "}")
                end,
            },
        },
        opts = function()
            local cmp = require("cmp")
            return {
                preselect = cmp.PreselectMode.None,
                window = {
                    completion = {
                        border = "rounded",
                        winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
                    },
                    documentation = {
                        border = "rounded",
                        winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
                    },
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<c-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Replace }),
                    ["<c-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Replace }),
                    ["<c-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<c-f>"] = cmp.mapping.scroll_docs(4),
                    ["<c-space>"] = cmp.mapping.complete(),
                    ["<c-e>"] = cmp.mapping.abort(),
                    ["<cr>"] = cmp.mapping({
                        i = function(fallback)
                            if cmp.visible() and cmp.get_active_entry() then
                                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                            else
                                fallback()
                            end
                        end,
                        s = cmp.mapping.confirm({ select = true }),
                        c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                    }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "path" },
                }, {
                    { name = "buffer" },
                }),
            }
        end,
        config = function(_, opts)
            require("cmp").setup(opts)
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },
}
