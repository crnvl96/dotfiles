return {
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdLineEnter" },
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "L3MON4D3/LuaSnip" },
        },
        config = function()
            local cmp = require("cmp")

            cmp.setup({
                preselect = cmp.PreselectMode.None,
                sorting = require("cmp.config.default")().sorting,
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.kind = ""
                        vim_item.menu = ({
                            buffer = "(Buffer)",
                            nvim_lsp = "(LSP)",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
                completion = {
                    completeopt = "menu,menuone,noinsert,noselect",
                },
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
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    {
                        name = "nvim_lsp",
                        entry_filter = function(entry)
                            local kind = cmp.lsp.CompletionItemKind[entry:get_kind()]
                            if kind == "Text" then
                                return false
                            end
                            if kind == "Snippet" then
                                return false
                            end
                            return true
                        end,
                    },
                }, {
                    { name = "buffer" },
                }),
            })

            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })
        end,
    },
}
