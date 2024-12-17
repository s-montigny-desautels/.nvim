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

	-- {
	-- 	"folke/zen-mode.nvim",
	-- 	config = function()
	-- 		require("zen-mode").setup({
	-- 			-- border = { "", "", "", "│", "", "", "", "│" },
	-- 			window = {
	-- 				backdrop = 0.95,
	-- 				height = 1,
	-- 				width = 180,
	-- 			},
	-- 		})
	--
	-- 		require("which-key").add({
	-- 			{ "<leader>z", group = "[Z]en Mode" },
	-- 		})
	--
	-- 		vim.keymap.set("n", "<leader>zz", require("zenmode").toggle, { desc = "Toggle NoNeckPain (Zen Mode)" })
	-- 	end,
	-- },

	{
		"shortcuts/no-neck-pain.nvim",
		version = "*",
		config = function()
			require("no-neck-pain").setup({
				width = 180,
				autocmds = {
					skipEnteringNoNeckPainBuffer = true,
				},
				integrations = {
					aerial = {
						position = "right",
						reopen = true,
					},
				},
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

			require("which-key").add({
				{ "<leader>r", group = "[R]ename" },
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

	{
		"stevearc/aerial.nvim",
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local aerial = require("aerial")

			aerial.setup({
				attach_mode = "global",
				backends = { "lsp", "treesitter" },
				show_guides = true,
				layout = {
					max_width = { 80, 0.4 },
					min_width = 40,
					resize_to_content = false,
					win_opts = {
						winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
						signcolumn = "yes",
						statuscolumn = " ",
					},
				},
				guides = {
					mid_item = "├╴",
					last_item = "└╴",
					nested_top = "│ ",
					whitespace = "  ",
				},
			})

			vim.keymap.set("n", "<leader>cs", "<cmd>AerialToggle<CR>", { desc = "Aerial (Symbols)" })
		end,
	},

	-- {
	-- 	"pocco81/auto-save.nvim",
	-- 	enabled = false,
	-- 	config = function()
	-- 		require("auto-save").setup({
	-- 			enabled = true,
	-- 			execution_message = {
	-- 				message = function()
	-- 					return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
	-- 				end,
	-- 				dim = 0.18,
	-- 				cleaning_interval = 1250,
	-- 			},
	-- 			trigger_events = { "InsertLeave", "TextChanged" },
	--
	-- 			condition = function(buf)
	-- 				local m = vim.api.nvim_get_mode().mode
	--
	-- 				if m == "i" then
	-- 					return false
	-- 				end
	--
	-- 				local file = vim.api.nvim_buf_get_name(0)
	--
	-- 				if string.find(file, "^oil") then
	-- 					return false
	-- 				end
	--
	-- 				if string.find(file, "__harpoon") then
	-- 					return
	-- 				end
	--
	-- 				local fn = vim.fn
	-- 				local utils = require("auto-save.utils.data")
	--
	-- 				if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
	-- 					return true
	-- 				end
	-- 				return false
	-- 			end,
	--
	-- 			write_all_buffers = false,
	-- 			debounce_delay = 1000,
	-- 			callbacks = {
	-- 				enabling = nil,
	-- 				disabling = nil,
	-- 				before_asserting_save = nil,
	-- 				before_saving = nil,
	-- 				after_saving = nil,
	-- 			},
	-- 		})
	-- 	end,
	-- },
}
