return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
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

					map({ "v" }, "<leader>hs", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, "git stage hunk")
					map("n", "<leader>hs", gs.stage_hunk, "Git [S]tage Hunk")
				end,
			})
		end,
	},
}
