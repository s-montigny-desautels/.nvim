local add = Config.add

local gh = Config.gh

local later = Config.later

later(function()
	add({ gh("lewis6991/gitsigns.nvim") })

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

			Config.keymap.map(
				"n",
				"]h",
				function() gs.nav_hunk("next") end,
				"Next hunk",
				{ buffer = buf }
			)

			Config.keymap.map(
				"n",
				"[h",
				function() gs.nav_hunk("prev") end,
				"Prev hunk",
				{ buffer = buf }
			)

			Config.keymap.map(
				"n",
				"<leader>gd",
				gs.preview_hunk_inline,
				"Git diff Current Line"
			)

			Config.keymap.map("n", "<leader>gr", gs.reset_hunk, "Git reset hunk")
		end,
	})
end)

later(function()
	add({ gh("tpope/vim-fugitive") })

	Config.keymap.nmap_leader("gD", "<cmd>Gvdiffsplit<CR>", "Git Diff File")
	Config.keymap.nmap_leader("gp", "<cmd>Git push<CR>", "Git Push")
	Config.keymap.nmap_leader(
		"gp",
		"<cmd>Git push --force-with-lease<CR>",
		"Git (safe) force push"
	)
end)

later(function()
	add({
		gh("NeogitOrg/neogit"),
		gh("sindrets/diffview.nvim"),
	})

	local neogit = require("neogit")
	neogit.setup({})

	Config.keymap.nmap_leader("gg", neogit.open, "Open neogit UI")
end)
