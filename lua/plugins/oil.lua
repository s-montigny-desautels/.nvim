return {
	{
		"stevearc/oil.nvim",
		-- dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		enabled = true,
		config = function()
			local detail = false
			require("oil").setup({
				columns = {},
				keymaps = {
					["<C-h>"] = false,
					["<C-l>"] = false,
					["<C-p>"] = false,
					["<M-h>"] = "actions.select_split",
					["<C-r>"] = "actions.refresh",
					["gd"] = {
						desc = "Toggle file detail view",
						callback = function()
							detail = not detail
							if detail then
								require("oil").set_columns({ "permissions", "size", "mtime" })
							else
								require("oil").set_columns({})
							end
						end,
					},
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
				local cwd = require("util").root_dir()
				require("oil").toggle_float(cwd)
			end, { desc = "Open workspace directory (float)" })

			vim.keymap.set("n", "<leader>e", function()
				require("oil").toggle_float()
			end, { desc = "Open current buffer directory (float)" })
		end,
	},
}
