vim.keymap.set("x", "@", function()
    return ":norm @" .. vim.fn.getcharstr() .. "<cr>"
end, { expr = true, desc = "Exec macro in the current visual selection", silent = true })

vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "<esc> and clear hlsearch", silent = true })
vim.keymap.set("i", "jk", "<esc>", { remap = true, desc = "Trigger <esc> in insert mode", silent = true })
vim.keymap.set("i", "kj", "<esc>", { remap = true, desc = "Trigger <esc> in insert mode", silent = true })

vim.keymap.set({ "n", "x" }, "J", "6j", { desc = "Enhanced <up> motion", silent = true })
vim.keymap.set({ "n", "x" }, "K", "6k", { desc = "Enhanced <down> motion", silent = true })

vim.keymap.set({ "n", "x", "o" }, "H", "_", { desc = "Goto start of line", silent = true })
vim.keymap.set({ "n", "x", "o" }, "L", "$", { desc = "Goto end of line", silent = true })

vim.keymap.set("n", "<leader>wd", "<c-w>c", { desc = "Close window", silent = true })
vim.keymap.set("n", "<leader>wx", "<cmd>only<cr>", { desc = "Close other windows", silent = true })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Go to last buffer", silent = true })
vim.keymap.set("n", "<leader>bx", "<cmd>%bd|edit#|bd#<cr>", { desc = "Close other buffers", silent = true })

vim.keymap.set("n", "<c-h>", "<c-w>h", { desc = "Goto left window", silent = true })
vim.keymap.set("n", "<c-j>", "<c-w>j", { desc = "Goto lower window", silent = true })
vim.keymap.set("n", "<c-k>", "<c-w>k", { desc = "Goto upper window", silent = true })
vim.keymap.set("n", "<c-l>", "<c-w>l", { desc = "Goto right window", silent = true })

vim.keymap.set("x", "<c-l>", "<cmd>resize +2<cr>", { desc = "Increase window height", silent = true })
vim.keymap.set("x", "<c-h>", "<cmd>resize -2<cr>", { desc = "Decrease window height", silent = true })

vim.keymap.set("x", "<c-j>", "<cmd>vertical resize -10<cr>", { desc = "Decrease window width", silent = true })
vim.keymap.set("x", "<c-k>", "<cmd>vertical resize +10<cr>", { desc = "Increase window width", silent = true })

vim.keymap.set("", "Y", "y$", { desc = "Yank to the end of line", silent = true })

vim.keymap.set("v", "p", '"_dp', { desc = "Paste after cursor without yanking selection", silent = true })
vim.keymap.set("v", "P", '"_dP', { desc = "Paste before cursor without yanking selection", silent = true })

vim.keymap.set("v", "<", "<gv", { desc = "Unindent selection", silent = true })
vim.keymap.set("v", ">", ">gv", { desc = "Indent selection", silent = true })

vim.keymap.set("", "<cr>", "", { desc = "Makes <cr> noop", silent = true })
vim.keymap.set("", "<bs>", "", { desc = "Makes <bs> noop", silent = true })
vim.keymap.set("", "<space>", "", { desc = "Makes <space> noop", silent = true })

vim.keymap.set("n", "j", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'j']], { expr = true, desc = "Moves <down> based on visual lines", silent = true })
vim.keymap.set("n", "k", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'k']], { expr = true, desc = "Moves <up> based on visual lines", silent = true })

vim.keymap.set("n", "<c-d>", "<c-d>zz", { desc = "Scrolls down and center cursor", silent = true })
vim.keymap.set("n", "<c-u>", "<c-u>zz", { desc = "Scrolls up and center cursor", silent = true })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { silent = true, expr = true, desc = "Next search result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { silent = true, expr = true, desc = "Next search result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { silent = true, expr = true, desc = "Next search result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { silent = true, expr = true, desc = "Prev search result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { silent = true, expr = true, desc = "Prev search result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { silent = true, expr = true, desc = "Prev search result" })
