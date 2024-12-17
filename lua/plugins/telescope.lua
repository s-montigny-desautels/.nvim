local util = require("util")
return {
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		enabled = false,
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

			local previewers = require("telescope.previewers")

			local new_maker = function(filepath, bufnr, opts)
				opts = opts or {}

				filepath = vim.fn.expand(filepath)
				vim.loop.fs_stat(filepath, function(_, stat)
					if not stat then
						return
					end
					if stat.size > 100000 then
						return
					else
						previewers.buffer_previewer_maker(filepath, bufnr, opts)
					end
				end)
			end

			telescope.setup({
				defaults = {
					buffer_previewer_maker = new_maker,
					wrap_result = true,
					layout_strategy = "horizontal",
					layout_config = { prompt_position = "top" },
					sorting_strategy = "ascending",
					path_display = {
						"filename_first",
						"truncate",
					},
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
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "ignore_case",
					},
				},
			})

			pcall(require("telescope").load_extension("fzf"))
			pcall(require("telescope").load_extension("ui-select"))
			pcall(require("telescope").load_extension("aerial"))

			local builtin = require("telescope.builtin")
			local map = function(keys, func, desc)
				vim.keymap.set("n", keys, func, { desc = desc })
			end

			-- map("<leader>ph", builtin.help_tags, "Search Help")
			-- map("<leader>pk", builtin.keymaps, "Search Keymaps")
			-- map("<leader>pf", function()
			-- 	builtin.find_files({
			-- 		cwd = require("util").root_dir(),
			-- 		hidden = true,
			-- 		no_ignore_parent = true,
			-- 	})
			-- end, "Search Files")

			-- map("<C-p>", function()
			-- 	if util.is_in_git() then
			-- 		builtin.git_files({ show_untracked = true })
			-- 	else
			-- 		builtin.find_files({
			-- 			cwd = require("util").root_dir(),
			-- 			hidden = true,
			-- 			no_ignore_parent = true,
			-- 		})
			-- 	end
			-- end, "Search Git Files")

			-- map("<leader>pw", builtin.grep_string, "Search current Word")
			-- map("<leader>pg", builtin.live_grep, "Search by Grep")
			-- map("<leader>pr", builtin.resume, "Search Resume")
			-- map("<leader>:", "<cmd>Telescope command_history<CR>", "Command History")
			-- map("<leader>/", builtin.current_buffer_fuzzy_find, "[/] Fuzzily search in current buffer")
			--
			-- map("<leader>pb", function()
			-- 	builtin.buffers({ sort_mru = true })
			-- end, "Search Buffers")
			--
			-- map("<leader>gs", "<cmd>Telescope git_status<CR>", "Git Status")
		end,
	},
}
