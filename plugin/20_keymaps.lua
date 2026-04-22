-- vim.keymap.set(
--   'n',
--   'j',
--   "v:count == 0 ? 'gj' : 'j'",
--   { desc = 'Down', expr = true, silent = true }
-- )
-- vim.keymap.set(
--   'n',
--   '<Down>',
--   "v:count == 0 ? 'gj' : 'j'",
--   { desc = 'Down', expr = true, silent = true }
-- )
-- vim.keymap.set(
--   'n',
--   'k',
--   "v:count == 0 ? 'gk' : 'k'",
--   { desc = 'Up', expr = true, silent = true }
-- )
-- vim.keymap.set(
--   'n',
--   '<Up>',
--   "v:count == 0 ? 'gk' : 'k'",
--   { desc = 'Up', expr = true, silent = true }
-- )

Config.keymap.nmap_leader("uw", "<cmd>set wrap!<CR>", "Toggle line wrap")

Config.keymap.vmap("J", ":m '>+1<CR>gv=gv")
Config.keymap.vmap("K", ":m '<-2<CR>gv=gv")

Config.keymap.nmap(
	"]d",
	function() vim.diagnostic.jump({ count = 1, float = true }) end
)
Config.keymap.nmap(
	"[d",
	function() vim.diagnostic.jump({ count = -1, float = true }) end
)

Config.keymap.nmap("<M-,>", "<c-w>5<", "Increase width")
Config.keymap.nmap("<M-.>", "<c-w>5>", "Decrease width")
Config.keymap.nmap("<M-t>", "<C-W>+", "Increase height")
Config.keymap.nmap("<M-s>", "<C-W>-", "Decrease height")

Config.keymap.nmap_leader("sq", "<cmd>qa<CR>", "[S]ession [Q]uit")

Config.keymap.xmap_leader("x", "p", [["_dP]])

Config.keymap.nmap_leader("y", [["+y]])
Config.keymap.xmap_leader("y", [["+y]])

Config.keymap.nmap_leader("Y", [["+Y]])

Config.keymap.nmap_leader(
	"ud",
	function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end,
	"Toggle Diagnostic"
)

-- Remap macro register
Config.keymap.nmap("<leader>Q", "q", "Register macro")
Config.keymap.nmap("q", "<nop>")

-- buffers
Config.keymap.nmap("[b", "<cmd>bprevious<cr>", "Prev Buffer")
Config.keymap.nmap("]b", "<cmd>bnext<cr>", "Next Buffer")
Config.keymap.nmap_leader("bb", "<cmd>e #<cr>", "Switch to Other Buffer")
Config.keymap.nmap_leader("`", "<cmd>e #<cr>", "Switch to Other Buffer")

-- Clear search with <esc>
vim.keymap.set(
	{ "i", "n" },
	"<esc>",
	"<cmd>noh<cr><esc>",
	{ desc = "Escape and Clear hlsearch" }
)

-- better indenting
Config.keymap.vmap("<", "<gv")
Config.keymap.vmap(">", ">gv")

-- lazy
-- set('n', '<leader>ll', '<cmd>Lazy<cr>', { desc = '[L]azy.nvim' })

Config.keymap.nmap_leader("cd", vim.diagnostic.open_float, "Line Diagnostics")

-- vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Enter Normal Mode' })
-- vim.keymap.set("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
-- vim.keymap.set("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

vim.cmd("packadd nvim.undotree")
Config.keymap.nmap_leader(
	"uu",
	function()
		require("undotree").open({
			command = math.floor(vim.api.nvim_win_get_width(0) / 3) .. "vnew",
		})
	end,
	"Toggle undotree"
)
