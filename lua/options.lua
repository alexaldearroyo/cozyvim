-- General
vim.opt.number = true -- Line numbers
vim.opt.relativenumber = true -- Relative numbers
vim.opt.mouse = "a" -- Enable mouse
vim.opt.clipboard = "unnamedplus" -- Copy/paste with the system
vim.opt.swapfile = false -- No swap files
vim.opt.backup = false
vim.opt.undofile = true -- Persistent undo

-- Tabs and spaces
vim.opt.tabstop = 4 -- Number of spaces for a tab
vim.opt.shiftwidth = 4 -- Number of spaces for indentation
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.smartindent = true -- Smart indentation

-- UI
vim.opt.termguicolors = true -- Enable true color support
vim.opt.cursorline = true -- Highlight the current line
vim.opt.signcolumn = "yes" -- Always show the sign column
vim.opt.wrap = true -- Enable line wrapping

-- Search
vim.opt.ignorecase = true -- Ignore case in search
vim.opt.smartcase = true -- Override ignorecase if uppercase is used
vim.opt.incsearch = true -- Incremental search
vim.opt.hlsearch = true -- Highlight search results

vim.opt.timeout = true
vim.opt.timeoutlen = 300 -- Time in ms for which-key to show

vim.opt.cmdheight = 0 -- Command line height

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
