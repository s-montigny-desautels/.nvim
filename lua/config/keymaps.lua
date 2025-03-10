local set = vim.keymap.set

set("n", "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
set("n", "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
set("n", "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
set("n", "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

set("n", "<leader>uw", "<cmd>set wrap!<CR>", { desc = "Toggle line wrap" })

-- set("n", "<leader>x", "<cmd>source %<CR>", { desc = "Execute the current file" })

set("v", "J", ":m '>+1<CR>gv=gv")
set("v", "K", ":m '<-2<CR>gv=gv")

set("n", "]d", vim.diagnostic.goto_next)
set("n", "[d", vim.diagnostic.goto_prev)

set("n", "<M-,>", "<c-w>5<", { desc = "Increase width" })
set("n", "<M-.>", "<c-w>5>", { desc = "Decrease width" })
set("n", "<M-t>", "<C-W>+", { desc = "Increase height" })
set("n", "<M-s>", "<C-W>-", { desc = "Decrease height" })

set("n", "<leader>sq", "<cmd>qa<CR>", { desc = "[S]ession [Q]uit" })

set("n", "<leader>ud", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle Diagnostic" })

-- Remap macro register
set("n", "<leader>Q", "q", { desc = "Register macro" })
set("n", "q", "<nop>")

-- buffers
set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
-- set("n", "<leader>bo", require("buffer").close_others, { desc = "Close all open buffer the active buffer" })
-- set("n", "<leader>bd", "<cmd>bp|bd #<cr>", { desc = "Close current buffer" })

-- Clear search with <esc>
set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- better indenting
set("v", "<", "<gv")
set("v", ">", ">gv")

-- lazy
set("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "[L]azy.nvim" })

-- Diagnostic
set("n", "]d", vim.diagnostic.goto_next)
set("n", "[d", vim.diagnostic.goto_prev)

set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

-- vim.keymap.set("n", "<c-/>", terminal.open, { desc = "Terminal" })
-- vim.keymap.set("n", "<c-_>", terminal.open, { desc = "wich_key_ignore" })

vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
vim.keymap.set("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
vim.keymap.set("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- vim.keymap.set("n", "<leader>lg", require("config.lazygit").open, { desc = "[L]azy[G]it" })
vim.keymap.set("n", "<leader>ld", require("config.lazydocker").open, { desc = "[L]azy[D]ocker" })

vim.keymap.set("n", "<leader>cgj", '0w"kyiwA<space>`json:"<esc>"kpb~A"`<esc>', {
	desc = "Generate GO json struc tag",
})
