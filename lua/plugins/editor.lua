return {
	{ "tpope/vim-sleuth" },
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{
		"folke/trouble.nvim",
		config = function()
			local function map(key, func, desc)
				vim.keymap.set("n", key, func, { desc = desc })
			end

			local trouble = require("trouble")
			trouble.setup({
				use_diagnostic_signs = true,
			})

			map("<leader>xx", "<cmd>TroubleToggle workspace_diagnostics<CR>", "Workspace Diagnostics (Trouble)")
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

			vim.keymap.set("n", "<leader>zz", "<cmd>:NoNeckPain<CR>", { desc = "Toggle NoNeckPain" })
		end,
	},
}
