local add = Config.add

local gh = Config.gh

local now, later = Config.now, Config.later

now(function() add({ { src = gh("rose-pine/neovim"), name = "rose-pine" } }) end)

now(function()
	add({ { src = gh("catppuccin/nvim"), name = "catppuccin" } })

	require("catppuccin").setup({
		flavour = "latte",
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

now(function() add({ gh("christoomey/vim-tmux-navigator") }) end)

later(function()
	add({ gh("folke/todo-comments.nvim") })

	require("todo-comments").setup({
		signs = false,
	})
end)

later(function()
	add({
		gh("MagicDuck/grug-far.nvim"),
	})

	require("grug-far").setup({})

	vim.keymap.set({ "n", "v" }, "<leader>rr", function()
		local grug = require("grug-far")
		local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
		grug.open({
			transient = true,
			prefills = {
				filesFilter = ext and ext ~= "" and "*." .. ext or nil,
			},
		})
	end)
end)

later(function()
	add({ gh("shortcuts/no-neck-pain.nvim") })

	require("no-neck-pain").setup({
		width = 180,
		autocmds = {
			skipEnteringNoNeckPainBuffer = true,
		},
	})

	-- TODO: Move to keymap file
	vim.keymap.set(
		"n",
		"<leader>zz",
		"<cmd>NoNeckPain<CR>",
		{ desc = "Toggle NoNeckPain (Zen Mode)" }
	)
end)

now(function()
	add({ gh("stevearc/oil.nvim") })

	-- TODO: Move to mini.file
	require("oil").setup({
		columns = {},
		keymaps = {
			["<C-h>"] = false,
			["<C-l>"] = false,
			["<C-p>"] = false,
			["<M-h>"] = "actions.select_split",
			["<C-r>"] = "actions.refresh",
		},
		view_options = {
			show_hidden = true,
		},
		default_file_explorer = true,
		skip_confirm_for_simple_edits = true,
		lsp_file_methods = {
			enabled = true,
			timeout_ms = 10000,
			autosave_changes = true,
		},
	})

	vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	vim.keymap.set("n", "<leader>w", function()
		local cwd = Config.util.root_dir()
		require("oil").toggle_float(cwd)
	end, { desc = "Open workspace directory (float)" })

	vim.keymap.set(
		"n",
		"<leader>e",
		function() require("oil").toggle_float() end,
		{ desc = "Open current buffer directory (float)" }
	)
end)

later(function()
	add({ gh("folke/snacks.nvim") })

	local Snacks = require("snacks")

	Config.new_autocmd("User", "OilActionsPost", function(event)
		if event.data.actions.type == "move" then
			Snacks.rename.on_rename_file(
				event.data.actions.src_url,
				event.data.actions.dest_url
			)
		end
	end, "OilMoveLSP")

	Snacks.setup({
		bigfile = { enabled = true },
		dashboard = { enabled = false },
		image = { enabled = true },
		picker = {
			main = {
				file = false,
			},
			layout = {
				hidden = { "preview" },
				layout = {
					box = "horizontal",
					width = 0.7,
					min_width = 120,
					height = 0.7,
					{
						box = "vertical",
						border = false,
						title = "{title} {live} {flags}",
						{ win = "input", height = 1, border = "bottom" },
						{ win = "list", border = "none" },
					},
					{
						win = "preview",
						title = "{preview}",
						border = false,
						width = 0.5,
					},
				},
			},
			matcher = {
				fuzzy = true,
				smartcase = false,
				ignorecase = true,
				sort_empty = false,
				filename_bonus = true,
				file_pos = true,
				cwd_bonus = false,
				frecency = true,
				history_bonus = true,
			},
			sort = {
				fields = { "score:desc", "#test", "idx" },
			},
			-- ui_select = true,
			toggles = {
				follow = "f",
				hidden = "h",
				ignored = "i",
				modified = "m",
				regex = { icon = "R", value = false },
			},
			icons = {
				files = {
					enabled = false,
				},
			},
		},
		quickfile = { enabled = true },
		statuscolumn = { enabled = false },
		words = { enabled = false },
		win = {
			position = "float",
			backdrop = 100,
			border = "single",
		},
	})

	Config.keymap.nmap_leader(
		"lg",
		function() Snacks.lazygit.open() end,
		"[L]azy[G]it"
	)

	Config.keymap.nmap_leader(
		"bo",
		require("snacks.bufdelete").other,
		"Close all open buffer except the active buffer"
	)

	Config.keymap.nmap_leader(
		"bd",
		require("snacks.bufdelete").delete,
		"Close current buffer"
	)

	-- Main Finder
	Config.keymap.nmap(
		"<C-p>",
		function()
			Snacks.picker.smart({
				filter = {
					cwd = true,
				},
			})
		end,
		"Search Project Files"
	)

	-- Finder
	Config.keymap.nmap_leader(
		"pf",
		function() Snacks.picker.files({ cwd = Config.util.root_dir() }) end,
		"Search Files"
	)

	Config.keymap.nmap_leader(
		"pc",
		function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,
		"Search Config File"
	)

	Config.keymap.nmap_leader("pw", Snacks.picker.grep_word, "Search by Grep")

	Config.keymap.nmap_leader("pg", Snacks.picker.grep, "Search by Grep")
	Config.keymap.nmap_leader("pr", Snacks.picker.resume, "Resume")
	Config.keymap.nmap_leader(":", Snacks.picker.command_history, "Command History")
	Config.keymap.nmap_leader(
		"/",
		Snacks.picker.grep_buffers,
		"[/] Fuzzily search buffers"
	)
	Config.keymap.nmap_leader("pb", Snacks.picker.buffers, "Search Buffers")
	Config.keymap.nmap_leader("gs", Snacks.picker.git_status, "Git Status")
	Config.keymap.nmap_leader("gS", Snacks.picker.git_stash, "Git Stash")
	Config.keymap.nmap_leader("gb", Snacks.picker.git_branches, "Git Branches")
	Config.keymap.nmap_leader("gl", Snacks.picker.git_log, "Git Log")
	Config.keymap.nmap_leader("gL", Snacks.picker.git_log_line, "Git Log Line")
	Config.keymap.nmap_leader("gf", Snacks.picker.git_log_file, "Git Log File")
	Config.keymap.nmap_leader("ph", Snacks.picker.help, "Search Help")
	Config.keymap.nmap_leader("pk", Snacks.picker.keymaps, "Search Keymaps")

	-- LSP
	Config.keymap.nmap("gd", Snacks.picker.lsp_definitions, "Goto Definition")
	Config.keymap.nmap("gD", Snacks.picker.lsp_declarations, "Goto Declaration")
	Config.keymap.nmap("gr", Snacks.picker.lsp_references, "Goto References")
	Config.keymap.nmap(
		"gI",
		Snacks.picker.lsp_implementations,
		"Goto Implementation"
	)
end)

later(function()
	add({ gh("lukas-reineke/indent-blankline.nvim") })

	require("ibl").setup({
		indent = {
			char = "│",
			tab_char = "│",
		},
		scope = { show_start = false, show_end = false },
	})
end)

later(function()
	add({ gh("folke/persistence.nvim") })

	local persistence = require("persistence")
	persistence.setup({
		options = { "buffers", "curdir", "tabpages", "winsize" },
	})

	vim.keymap.set(
		"n",
		"<leader>sr",
		persistence.load,
		{ desc = "[S]ession [R]eload" }
	)
end)

later(function()
	add({ gh("windwp/nvim-ts-autotag") })

	require("nvim-ts-autotag").setup({
		opts = {
			enable_close = true,
			enable_rename = true,
			enable_close_on_slash = false,
		},
	})
end)

later(function()
	add({ gh("lewis6991/gitsigns.nvim") })

	require("gitsigns").setup({
		signs_staged_enable = false,
		signcolumn = false,
		current_line_blame = true,
		auto_attach = true,
		current_line_blame_opts = {
			delay = 500,
		},
	})
end)
