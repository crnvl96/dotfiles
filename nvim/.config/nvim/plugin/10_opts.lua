local default_nodejs = vim.env.HOME .. '/.local/share/mise/installs/node/22.14.0/bin/'
vim.g.node_host_prog = default_nodejs .. 'node' -- Default node version used by nvim
vim.env.PATH = default_nodejs .. ':' .. vim.env.PATH -- Update neovim path

if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end -- Syntax highlight
vim.cmd('filetype plugin indent on') -- Filetype detection; Filetype plugins; Indentation scripts
vim.cmd('packadd cfilter') -- Allow iltering the QF list

vim.o.fillchars = table.concat({
    'diff:/', -- git diff
    'eob:~', -- end of buffer sign
    'fold:╌', -- fold markers
}, ',')

vim.o.listchars = table.concat({
    'precedes:…', -- Lines starting before the screen left edge
    'extends:…', -- Lines extending past the screen right edge
    'nbsp:␣', -- Non-breaking spaces
    'tab:  ', -- Tabs (two spaces)
}, ',')

vim.o.diffopt = table.concat({
    'internal', -- Use internal diff library
    'filler', -- Show filler lines for deleted lines, keeping text aligned
    'closeoff', -- Don't display '^M' at end of lines when 'fileformats' has "dos"
    'context:5', -- Show 5 lines of context around differences
    'algorithm:histogram', -- Use the histogram diff algorithm for better results
    'linematch:60', -- Enable the linematch algorithm (default is 60 seconds)
    'indent-heuristic', -- Enable indent heuristic for finding block moves
    -- 'inline:word', -- Show inline diffs at the word level (requires compatible diff tool)
}, ',')

vim.o.grepprg = table.concat({
    'rg',
    '--vimgrep',
    '--smart-case',
}, ' ')

vim.g.mapleader = ' ' -- <Space>  as leader key
vim.g.maplocalleader = ',' -- comma as local leader key

vim.o.breakindent = true -- Wrapped lines will continue visually indented
vim.o.clipboard = 'unnamed' -- Make \" the default register
vim.o.conceallevel = 0 -- Adjust conceal
vim.o.cursorline = false -- No cursorline
vim.o.expandtab = true -- Convert tabs into spaces
vim.o.foldlevel = 99 -- All folds under this value will be closed
vim.o.foldlevelstart = 99 -- Useful to always start editing with all folds closed
vim.o.foldmethod = 'expr' -- 'foldexpr' gives the fold level of a line.
vim.o.ignorecase = true -- Ignore case in search patterns
vim.o.infercase = true -- Smart case handling when searching patterns
vim.o.laststatus = 0 -- No statusbar
vim.o.linebreak = true -- Avoid breaking words in the middle when line is break
vim.o.list = true -- Show special symbols (Such as tabs, trailing spaces, etc...)
vim.o.mouse = 'a' -- Enable mouse in all modes
vim.o.number = true -- Enable line numbers
vim.o.relativenumber = true -- Enable relative line numbers
vim.o.ruler = false -- Don't show cursor position on statusline
vim.o.scrolloff = 8 -- Always keep a vertical gap between cursor and the edges of the screen
vim.o.shiftwidth = 4 -- Number of spaces to use for each step of indent
vim.o.showcmd = false -- Don't show the command being tapped on the statusline
vim.o.showmode = false -- Don't show current mode on the statusline
vim.o.sidescrolloff = 8 -- Always keep a horizontal gap between cursor and the edges of the screen
vim.o.signcolumn = 'yes' -- Let nvim handle the signcolumn
vim.o.smartcase = true -- Don't consider 'ignorecase' if the pattern has uppercase letters
vim.o.softtabstop = 4 -- Number of spaces that a <TAB> counts for
vim.o.splitbelow = true -- Split screens to below
vim.o.splitkeep = 'screen' -- Avoid vertical movement when splitting screens
vim.o.splitright = true -- Split screens to the right
vim.o.swapfile = false -- Disable swapfile
vim.o.tabstop = 4 -- Number of spaces that a <Tab> counts for
vim.o.undofile = true -- Enable persistent undo
vim.o.virtualedit = 'block' -- Block selection on visual mode
vim.o.wildignorecase = true -- Case is ignored when completing file names and directories
vim.o.winborder = 'single' -- Default border style of the floating windows
vim.o.wrap = false -- Disable linewrap
vim.o.writebackup = false -- Don't make a backup when overwriting a file
