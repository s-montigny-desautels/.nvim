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
							["<c-d>"] = actions.delete_buffer,
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
				["<leader>p"] = { name = "[P]rompt", _ = "which_key_ignore" },
			})

			map("<leader>ph", builtin.help_tags, "Search Help")
			map("<leader>pk", builtin.keymaps, "Search Keymaps")
			map("<leader>pf", function()
				builtin.find_files({
					cwd = require("util").root_dir(),
					hidden = true,
					no_ignore_parent = true,
				})
			end, "Search Files")

			map("<C-p>", function()
				builtin.git_files({ show_untracked = true })
			end, "Search Git Files")

			map("<leader>pw", builtin.grep_string, "Search current Word")
			map("<leader>pg", builtin.live_grep, "Search by Grep")
			map("<leader>pr", builtin.resume, "Search Resume")
			map("<leader>:", "<cmd>Telescope command_history<CR>", "Command History")
			map("<leader>/", builtin.current_buffer_fuzzy_find, "[/] Fuzzily search in current buffer")

			map("<leader>pb", builtin.buffers, "Search Buffers")
		end,
	},
}
