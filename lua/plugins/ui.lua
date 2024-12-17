return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "auto",
					globalstatus = true,
					component_separators = "|",
					section_separators = "",
				},
				sections = {
					lualine_a = {
						{
							function()
								return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
							end,
						},
					},
					lualine_b = { "branch" },
					lualine_c = {
						{
							"filetype",
							colored = true,
							icon_only = true,
							separator = "",
							padding = { left = 1, right = 0 },
						},
						{ "filename", file_status = true, newfile_status = true, path = 1 },
						{ "aerial", sep = " ", sep_icon = "", depth = 5, dense = false, dense_sep = ".", colored = true },
					},
					lualine_x = {
						{
							"diagnostics",
							symbols = {
								error = " ",
								warn = " ",
								hint = " ",
								info = " ",
							},
						},
						{
							"diff",
							symbols = {
								added = " ",
								modified = " ",
								removed = " ",
							},
							source = function()
								local gitsigns = vim.b.gitsigns_status_dict
								if gitsigns then
									return {
										added = gitsigns.added,
										modified = gitsigns.changed,
										removed = gitsigns.removed,
									}
								end
							end,
						},
					},
					lualine_y = {
						{ "progress", seperator = " ", padding = { left = 1, right = 0 } },
						{ "location", padding = { left = 0, right = 1 } },
					},
				},
			})
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			require("ibl").setup({
				indent = {
					char = "│",
					tab_char = "│",
				},
				scope = { show_start = false, show_end = false },
			})
		end,
	},

	{
		"folke/which-key.nvim",
		config = function()
			local which_key = require("which-key")
			which_key.setup({
				preset = "helix",
				plugins = {
					marks = false,
					registers = false,
					spelling = {
						enabled = false,
					},
					presets = {
						operators = false, -- adds help for operators like d, y, ...
						motions = false, -- adds help for motions
						text_objects = false, -- help for text objects triggered after entering an operator
						windows = true, -- default bindings on <c-w>
						nav = true, -- misc bindings to work with windows
						z = true, -- bindings for folds, spelling and others prefixed with z
						g = true, -- bindings for prefixed with g
					},
				},
			})

			which_key.add({
				{ "<leader>b", group = "[B]uffer" },
				{ "<leader>u", group = "[U]i Toggle" },
			})
		end,
	},

	-- Enable to show fancy rename prompt
	-- {
	-- 	"stevearc/dressing.nvim",
	-- 	enabled = true,
	-- 	config = function()
	-- 		require("dressing").setup({})
	-- 	end,
	-- },
}
