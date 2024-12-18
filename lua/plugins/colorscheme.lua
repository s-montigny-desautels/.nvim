return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "latte",
				transparent_background = false,
				highlight_overrides = {
					all = function(colors)
						return {
							-- https://github.com/catppuccin/nvim/issues/699
							-- The default color is bad for my color blindness
							["@keyword.operator"] = { fg = colors.mauve },

							BlinkCmpKind = { fg = colors.blue },
							BlinkCmpMenu = { fg = colors.text },
							BlinkCmpMenuBorder = { fg = colors.blue },
							BlinkCmpDocBorder = { fg = colors.blue },
							BlinkCmpSignatureHelpActiveParameter = { fg = colors.mauve },
						}
					end,
				},
				show_end_of_buffer = false,
				term_colors = false,
				no_italic = false,
				no_bold = false,
				no_underline = false,
				styles = {
					comments = { "italic" },
					conditionals = { "italic" },
					loops = {},
					functions = {},
					keywords = {},
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
				},
				integrations = {
					cmp = false,
					blink_cmp = true,
					dashboard = true,
					gitsigns = true,
					illuminate = true,
					indent_blankline = { enabled = true },
					leap = true,
					lsp_trouble = true,
					mason = true,
					markdown = true,
					mini = true,
					fidget = true,
					render_markdown = false,
					native_lsp = {
						enabled = true,
						underlines = {
							errors = { "undercurl" },
							hints = { "undercurl" },
							warnings = { "undercurl" },
							information = { "undercurl" },
						},
					},
					navic = { enabled = true, custom_bg = "lualine" },
					neotest = true,
					semantic_tokens = true,
					telescope = true,
					fzf=true,
					treesitter = true,
					treesitter_context = true,
					which_key = true,
				},
			})
		end,
	},
}
