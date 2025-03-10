return {
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gD", "<cmd>Gvdiffsplit<CR>", { desc = "Git Diff File" })
			vim.keymap.set("n", "<leader>gg", "<cmd>0G<CR>", { desc = "Git fugitive" })
			vim.keymap.set("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "Git push" })
			vim.keymap.set(
				"n",
				"<leader>gP",
				"<cmd>Git push --force-with-lease<CR>",
				{ desc = "Git (safe) force push" }
			)
		end,
	},
	{
		"tpope/vim-unimpaired",
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("which-key").add({
				{ "<leader>g", group = "[G]it" },
			})

			require("gitsigns").setup({
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
				current_line_blame = true,
				current_line_blame_opts = {
					delay = 500,
					virt_text_pos = "eol",
				},
				on_attach = function(buf)
					local gs = require("gitsigns")
					local function map(mode, key, func, desc)
						vim.keymap.set(mode, key, func, { buffer = buf, desc = desc })
					end

					map("n", "]h", function()
						gs.nav_hunk("next")
					end, "Next Hunk")

					map("n", "[h", function()
						gs.nav_hunk("prev")
					end, "Prev Hunk")

					map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
					map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")

					map("n", "<leader>ub", gs.toggle_current_line_blame, "Toggle Current Line [B]lame")
					map("n", "<leader>gd", gs.preview_hunk_inline, "Git Diff Current Line")
					map("n", "<leader>gr", gs.reset_hunk, "Git Reset Hunk")
				end,
			})
		end,
	},
}
