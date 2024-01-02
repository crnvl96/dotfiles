vim.keymap.set("x", "@", function()
    return ":norm @" .. vim.fn.getcharstr() .. "<cr>"
end, { expr = true })

vim.keymap.set("n", "<C-p>", '<cmd>let @+ = expand("%:p")<CR>')

vim.keymap.set("v", "p", '"_dp')
vim.keymap.set("v", "P", '"_dP')

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set({ "n", "x" }, "J", "6j", { remap = true })
vim.keymap.set({ "n", "x" }, "K", "6k", { remap = true })

vim.keymap.set("", "Y", "y$")

vim.keymap.set({ "n", "x", "o" }, "H", "_", { remap = true })
vim.keymap.set({ "n", "x", "o" }, "L", "$", { remap = true })

vim.keymap.set("", "<CR>", "")
vim.keymap.set("", "<BS>", "")
vim.keymap.set("", "<Space>", "")

vim.keymap.set("n", "j", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'j']], { expr = true })
vim.keymap.set("n", "k", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'k']], { expr = true })

vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
vim.keymap.set("i", "jk", "<esc>", { remap = true })
vim.keymap.set("i", "kj", "<esc>", { remap = true })

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<M-k>", "<cmd>resize +2<cr>")
vim.keymap.set("n", "<M-j>", "<cmd>resize -2<cr>")
vim.keymap.set("n", "<M-h>", "<cmd>vertical resize -2<cr>")
vim.keymap.set("n", "<M-l>", "<cmd>vertical resize +2<cr>")

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true })
