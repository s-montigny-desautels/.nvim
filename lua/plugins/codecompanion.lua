return {
	{
		"olimorris/codecompanion.nvim",
		lazy = false,
		config = function()
			require("codecompanion").setup({
				adapters = {
					gemini = function()
						return require("codecompanion.adapters").extend("gemini", {
							env = {
								api_key = "cmd:op read op://Employee/gemini/credential --no-newline",
							},
							-- model = "gemini-2.5-pro"
						})
					end,
				},

				strategies = {
					chat = {
						adapter = "gemini",
					},
					inline = {
						adapter = "gemini",
					},
					agent = {
						adapter = "gemini",
					},
				},
			})
		end,
	},
}
