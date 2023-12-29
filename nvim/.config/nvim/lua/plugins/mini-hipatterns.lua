return {
    {
        "echasnovski/mini.hipatterns",
        event = "BufReadPost",
        dependencies = {
            { "echasnovski/mini.extra" },
        },
        opts = function()
            local hi_words = require("mini.extra").gen_highlighter.words
            local hipatterns = require("mini.hipatterns")
            return {
                highlighters = {
                    todo = hi_words({ "TODO", "Todo", "todo" }, "MiniHipatternsTodo"),
                    hack = hi_words({ "HACK", "Hack", "hack" }, "MiniHipatternsHack"),
                    fixme = hi_words({ "FIXME", "Fixme", "fixme" }, "MiniHipatternsFixme"),
                    note = hi_words({ "NOTE", "Note", "note" }, "MiniHipatternsNote"),
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            }
        end,
    },
}
