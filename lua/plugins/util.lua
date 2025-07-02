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


	{ "nvim-lua/plenary.nvim", lazy = true },
}
