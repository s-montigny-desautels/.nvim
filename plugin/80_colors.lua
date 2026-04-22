local now, add, gh = Config.now, Config.add, Config.gh

now(function() add({ { src = gh("rose-pine/neovim"), name = "rose-pine" } }) end)

now(function()
	add({ { src = gh("catppuccin/nvim"), name = "catppuccin" } })

	require("catppuccin").setup({
		transparent_background = false,
		highlight_overrides = {
			all = function(colors)
				return {
					-- https://github.com/catppuccin/nvim/issues/698
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
end)

now(function()
	local set_theme = function(val)
		if val == nil then return end

		val = vim.trim(val)
		vim.schedule(function()
			if val == "1" then
				vim.cmd("colorscheme catppuccin-mocha")
			elseif val == "0" then
				vim.cmd("colorscheme catppuccin-latte")
			end
		end)
	end

	vim.system({ "gnome-theme-watcher" }, {
		stdout = function(_, val) set_theme(val) end,
	})

	vim.system(
		{ "gnome-theme-watcher", "--watch" },
		{ stdout = function(_, val) set_theme(val) end }
	)
end)
