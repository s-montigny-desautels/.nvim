return {
	{
		"nvim-telescope/telescope.nvim",
		version = false,
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons" },
		},

		config = function()
			local telescope = require("telescope")

			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					wrap_result = true,
					layout_strategy = "horizontal",
					layout_config = { prompt_position = "top" },
					sorting_strategy = "ascending",
					mappings = {
						n = {
							["q"] = actions.close,
							["<c-d>"] = actions.delete_buffer
						},
					},
				},
				pickers = {
					diagnostics = {
						theme = "ivy",
						initial_mode = "normal",
					},
				},
				fzf = {},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			pcall(require("telescope").load_extension("fzf"))
			pcall(require("telescope").load_extension("ui-select"))

			local builtin = require("telescope.builtin")
			local map = function(keys, func, desc)
				vim.keymap.set("n", keys, func, { desc = desc })
			end

			require("which-key").register({
				["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
			})

			map("<leader>sh", builtin.help_tags, "[S]earch [H]elp")
			map("<leader>sk", builtin.keymaps, "[S]earch [K]eymaps")
			map("<leader>sf", builtin.find_files, "[S]earch [F]iles")
			map("<leader>sw", builtin.grep_string, "[S]earch current [W]ord")
			map("<leader>sg", builtin.live_grep, "[S]earch by [G]rep")
			map("<leader>sr", builtin.resume, "[S]earch [R]esume")
			map("<leader>s.", builtin.oldfiles, "[S]earch Recent Files")
			map("<leader>:", "<cmd>Telescope command_history<CR>", "Command History")
			map("<leader>/", builtin.current_buffer_fuzzy_find, "[/] Fuzzily search in current buffer")

			-- From LazyVim, keep for now so I can migrate to <leader>sf
			map("<leader><space>", builtin.buffers, "Find Files")
		end,
	},
}
