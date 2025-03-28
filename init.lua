vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("options")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("config") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', lazypath})
end
vim.opt.rtp:prepend(lazypath)

-- Resets buffer size when resizing the window
vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    callback = function()
        vim.cmd("wincmd =")
        vim.cmd("redraw!")
    end
})

-- 🔑 KEYMAPS

local keymap = vim.keymap.set

keymap("n", "<leader>x", ":bd<CR>", {
    noremap = true,
    silent = true,
    desc = "Close buffer"
})

-- Save current buffer
keymap("n", "<leader>w", ":w<CR>", {
    noremap = true,
    silent = true,
    desc = "Save"
})
keymap("n", "<leader>q", function()
    if vim.bo.modified then
        vim.cmd("confirm q")
    else
        vim.cmd("q")
    end
end, {
    noremap = true,
    silent = true,
    desc = "Quit"
})

-- Quit all, with confirmation if there are modified buffers
keymap("n", "<leader>Q", function()
    if vim.fn.getbufinfo({
        bufmodified = 1
    })[1] then
        vim.cmd("confirm qa")
    else
        vim.cmd("qa")
    end
end, {
    noremap = true,
    silent = true,
    desc = "Quit All"
})

-- Navigation
keymap({"n", "v", "o"}, "§", "0", {
    noremap = true,
    desc = "Start of line"
})
keymap({"n", "v", "o"}, "0", "$", {
    noremap = true,
    desc = "End of line"
})

keymap({"n", "v", "o"}, "±", "gg", {
    noremap = true,
    desc = "Top of file"
})
keymap({"n", "v", "o"}, ")", "G", {
    noremap = true,
    desc = "Bottom of file"
})

keymap({"n", "v", "o"}, "\\", "%", {
    noremap = true,
    desc = "Matching pair"
})

keymap({"n", "v", "o"}, "<leader>k", "<C-u>", {
    noremap = true,
    desc = "Scroll up"
})

keymap({"n", "v", "o"}, "<leader>j", "<C-d>", {
    noremap = true,
    desc = "Scroll down"
})

-- Folding
keymap({"n", "v"}, "zh", "zc", {
    noremap = true,
    desc = "Fold"
})
keymap({"n", "v"}, "zx", "zc", {
    noremap = true,
    desc = "Fold"
})

keymap({"n", "v"}, "zl", "zo", {
    noremap = true,
    desc = "Unfold"
})
keymap({"n", "v"}, "zo", "zo", {
    noremap = true,
    desc = "Unfold"
})

keymap({"n", "v"}, "zu", "zR", {
    noremap = true,
    desc = "Fold All"
})
keymap({"n", "v"}, "za", "zM", {
    noremap = true,
    desc = "Unfold All"
})

-- 📐 Splits
keymap("n", "<leader>sj", ":vsplit<CR>", {
    desc = "Split vertical"
})
keymap("n", "<leader>sk", ":vsplit<CR>", {
    desc = "Split vertical"
})

keymap("n", "<leader>sh", ":split<CR>", {
    desc = "Split horizontal"
})
keymap("n", "<leader>sl", ":split<CR>", {
    desc = "Split horizontal"
})

keymap("n", "<leader>sx", "<C-w>c", {
    desc = "Close split"
})

-- 🧭 Movement between splits
keymap("n", "<C-h>", "<C-w>h", {
    desc = "Move left"
})
keymap("n", "<C-l>", "<C-w>l", {
    desc = "Move right"
})
keymap("n", "<C-j>", "<C-w>j", {
    desc = "Move down"
})
keymap("n", "<C-k>", "<C-w>k", {
    desc = "Move up"
})

require("lazy").setup("plugins")
