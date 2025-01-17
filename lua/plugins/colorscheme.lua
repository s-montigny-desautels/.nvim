return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		enabled = true,
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

							NormalFloat = { bg = "none" },
							FloatBorder = { bg = "none" },
							FloatTitle = { bg = "none" },
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
					fzf = true,
					treesitter = true,
					treesitter_context = true,
					which_key = true,
				},
			})
		end,
	},

	{
		"rebelot/kanagawa.nvim",
		name = "kanagawa",
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				compile = false,
				undercurl = true,
				commentStyle = { italic = true },
				functionStyle = {},
				keywordStyle = { italic = true },
				statementStyle = { bold = true },
				typeStyle = {},
				transparent = false, -- do not set background color
				dimInactive = false, -- dim inactive window `:h hl-NormalNC`
				terminalColors = true, -- define vim.g.terminal_color_{0,17}
				colors = { -- add/modify theme and palette colors
					palette = {},
					theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
				},
				overrides = function(colors)
					local theme = colors.theme
					return {
						-- Completion menu
						Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
						PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
						PmenuSbar = { bg = theme.ui.bg_m1 },
						PmenuThumb = { bg = theme.ui.bg_p2 },

						-- Better floating window
						NormalFloat = { bg = "none" },
						FloatBorder = { bg = "none" },
						FloatTitle = { bg = "none" },

						-- Save an hlgroup with dark background and dimmed foreground
						-- so that you can use it where your still want darker windows.
						-- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
						NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
					}
				end,
				theme = "lotus", -- Load "wave" theme when 'background' option is not set
			})
		end,
	},
	{
		"xzbdmw/colorful-menu.nvim",
		config = function()
			require("colorful-menu").setup()
		end,
	},
}
