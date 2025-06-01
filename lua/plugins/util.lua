return {
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		config = function()
			local persistence = require("persistence")
			persistence.setup({
				options = { "buffers", "curdir", "tabpages", "winsize" },
			})

			require("which-key").add({
				{ "<leader>s", group = "[S]ession Management" },
			})

			vim.keymap.set("n", "<leader>sr", persistence.load, { desc = "[S]ession [R]eload" })
		end,
	},

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			local Snacks = require("snacks")
			Snacks.setup({
				bigfile = { enabled = true },
				dashboard = { enabled = false },
				notifier = {
					enabled = false,
					timeout = 3000,
				},
				quickfile = { enabled = true },
				statuscolumn = { enabled = false },
				words = { enabled = true },
				terminal = {},
				win = {
					position = "float",
					backdrop = 100,
					border = "rounded",
				},
			})

			vim.keymap.set({ "n", "t" }, "]]", function()
				Snacks.words.jump(vim.v.count1)
			end, { desc = "Next Reference" })

			vim.keymap.set({ "n", "t" }, "[[", function()
				Snacks.words.jump(-vim.v.count1)
			end, { desc = "Prev Reference" })

			-- vim.keymap.set("n", "<c-/>", function()
			-- 	Snacks.terminal(nil, { win = { position = "float" } })
			-- end, { desc = "Terminal" })
			--
			-- vim.keymap.set("n", "<c-_>", function()
			-- 	Snacks.terminal(nil, { win = { position = "float" } })
			-- end, { desc = "wich_key_ignore" })

			vim.keymap.set("n", "<leader>lg", function()
				Snacks.lazygit.open()
			end, { desc = "[L]azy[G]it" })

			vim.keymap.set("n", "<leader>bo", require("snacks.bufdelete").other, {
				desc = "Close all open buffer except the active buffer",
			})

			vim.keymap.set("n", "<leader>bd", require("snacks.bufdelete").delete, {
				desc = "Close current buffer",
			})
		end,
	},

	{ "nvim-lua/plenary.nvim", lazy = true },
}
