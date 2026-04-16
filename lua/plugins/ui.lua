return {
	{
		"nvim-lualine/lualine.nvim",
		enabled = false,
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = false,
					theme = "auto",
					globalstatus = true,
					component_separators = "|",
					section_separators = "",
				},
				extensions = { "oil" },
				sections = {
					lualine_a = {},
					lualine_b = { "branch" },
					lualine_c = {
						{ "filename", file_status = true, newfile_status = true, path = 1 },
					},
					lualine_x = {
						"diagnostics",
						"diff",
					},
				},
			})
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		enabled = true,
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

	-- {
	-- 	"folke/which-key.nvim",
	-- 	config = function()
	-- 		local which_key = require("which-key")
	-- 		which_key.setup({
	-- 			preset = "helix",
	-- 			plugins = {
	-- 				marks = false,
	-- 				registers = false,
	-- 				spelling = {
	-- 					enabled = false,
	-- 				},
	-- 				presets = {
	-- 					operators = false, -- adds help for operators like d, y, ...
	-- 					motions = false, -- adds help for motions
	-- 					text_objects = false, -- help for text objects triggered after entering an operator
	-- 					windows = true, -- default bindings on <c-w>
	-- 					nav = true, -- misc bindings to work with windows
	-- 					z = true, -- bindings for folds, spelling and others prefixed with z
	-- 					g = true, -- bindings for prefixed with g
	-- 				},
	-- 			},
	-- 		})
	--
	-- 		which_key.add({
	-- 			{ "<leader>b", group = "[B]uffer" },
	-- 			{ "<leader>u", group = "[U]i Toggle" },
	-- 		})
	-- 	end,
	-- },
}
