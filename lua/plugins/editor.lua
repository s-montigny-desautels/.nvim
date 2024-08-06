return {
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		config = function()
			require("todo-comments").setup({
				signs = false,
			})
		end,
	},
	{
		"folke/trouble.nvim",
		config = function()
			local function map(key, func, desc)
				vim.keymap.set("n", key, func, { desc = desc })
			end

			local trouble = require("trouble")
			trouble.setup({
				modes = { lsp = { win = { position = "right" } } },
			})

			map("<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", "Workspace Diagnostics (Trouble)")
			map("[q", function()
				if trouble.is_open() then
					trouble.previous({ skip_groups = true, jump = true })
				else
					local ok, err = pcall(vim.cmd.cprev)
					if not ok then
						vim.notify(err, vim.log.levels.ERROR)
					end
				end
			end, "Previous Trouble/Quickfix Item")

			map("]q", function()
				if trouble.is_open() then
					trouble.next({ skip_groups = true, jump = true })
				else
					local ok, err = pcall(vim.cmd.cnext)
					if not ok then
						vim.notify(err, vim.log.levels.ERROR)
					end
				end
			end, "Next Trouble/Quickfix Item")
		end,
	},

	{
		"shortcuts/no-neck-pain.nvim",
		version = "*",
		config = function()
			require("no-neck-pain").setup({
				width = 200,
			})

			require("which-key").add({
				{ "<leader>z", group = "[Z]en Mode" },
			})

			vim.keymap.set("n", "<leader>zz", "<cmd>:NoNeckPain<CR>", { desc = "Toggle NoNeckPain (Zen Mode)" })
		end,
	},

	{
		"nvim-pack/nvim-spectre",
		build = false,
		config = function()
			require("spectre").setup({
				open_cmd = "noswapfile vnew",
			})

			vim.keymap.set("n", "<leader>rr", function()
				require("spectre").toggle()
			end, { desc = "Toggle Spectre" })

			vim.keymap.set("n", "<leader>rw", function()
				require("spectre").open_visual({ select_word = true })
			end, { desc = "Search current word" })

			vim.keymap.set("v", "<leader>rw", function()
				require("spectre").open_visual()
			end, { desc = "Search current word" })
		end,
	},

	-- Auto close html tags
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = true,
					enable_rename = true,
					enable_close_on_slash = false,
				},
			})
		end,
	},

	-- Enhance Neovim's native comments:
	{
		"folke/ts-comments.nvim",
		config = function()
			require("ts-comments").setup()
		end,
	},

	{
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>uu", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })
		end,
	},
}
