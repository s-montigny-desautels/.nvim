-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local Util = require("lazyvim.util")

-- Move swap the current line up or down and swap line in splace
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor centered in screen when half jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "<leader>hv", function()
    vim.cmd("%!xxd")
end)

vim.keymap.del({ "n", "x" }, "j")
vim.keymap.del({ "n", "x" }, "<Down>")
vim.keymap.del({ "n", "x" }, "k")
vim.keymap.del({ "n", "x" }, "<Up>")

vim.keymap.del("n", "<A-j>")
vim.keymap.del("n", "<A-k>")
vim.keymap.del("i", "<A-j>")
vim.keymap.del("i", "<A-k>")
vim.keymap.del("v", "<A-j>")
vim.keymap.del("v", "<A-k>")

-- Terminal
local lazyterm = function(opts)
    Util.terminal(
        nil,
        vim.tbl_deep_extend("force", {
            cwd = Util.root(),
            border = "rounded",
            env = {
                TMUX = "",
            },
        }, opts or {})
    )
end

vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")

vim.keymap.set("n", "<c-/>", lazyterm, { desc = "Terminal (root dir)" })
vim.keymap.set("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })

vim.keymap.set("n", "<leader>Q", "q", { desc = "Register macro" })
vim.keymap.set("n", "q", "<nop>")

