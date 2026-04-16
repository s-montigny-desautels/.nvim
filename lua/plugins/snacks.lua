---@class mapOpts
---@field mode? string|string[]
---@field desc? string

---@param key string
---@param fn function
---@param opts? mapOpts|{}
local map = function(key, fn, opts)
	opts = opts or {}
	if not opts.mode then
		opts.mode = "n"
	end

	vim.keymap.set(opts.mode, key, fn, { desc = opts.desc })
end

return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		init = function()
			local Snacks = require("snacks")

			vim.api.nvim_create_autocmd("User", {
				pattern = "OilActionsPost",
				callback = function(event)
					if event.data.actions.type == "move" then
						Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
					end
				end,
			})
		end,
		config = function()
			local Snacks = require("snacks")
			Snacks.setup({
				bigfile = { enabled = true },
				dashboard = { enabled = false },
				image = {
					enabled = true,
				},
				-- input = {
				-- 	enabled = true,
				-- 	prompt_pos = "left",
				-- 	win = {
				-- 		relative = "cursor",
				-- 		row = 1,
				-- 		col = -2,
				-- 	},
				-- },
				quickfile = { enabled = true },
				statuscolumn = { enabled = false },
				-- words = { enabled = true },
				terminal = {},
				win = {
					position = "float",
					backdrop = 100,
					border = "rounded",
				},
			})

			-- map("]]", function()
			-- 	Snacks.words.jump(vim.v.count1)
			-- end, { mode = { "n", "t" }, desc = "Next Reference" })
			--
			-- map("[[", function()
			-- 	Snacks.words.jump(-vim.v.count1)
			-- end, { desc = "Prev Reference", mode = { "n", "t" } })

			-- vim.keymap.set("n", "<c-/>", function()
			-- 	Snacks.terminal(nil, { win = { position = "float" } })
			-- end, { desc = "Terminal" })
			--
			-- vim.keymap.set("n", "<c-_>", function()
			-- 	Snacks.terminal(nil, { win = { position = "float" } })
			-- end, { desc = "wich_key_ignore" })

			map("<leader>lg", function()
				Snacks.lazygit.open()
			end, { desc = "[L]azy[G]it" })

			map("<leader>bo", require("snacks.bufdelete").other, {
				desc = "Close all open buffer except the active buffer",
			})

			map("<leader>bd", require("snacks.bufdelete").delete, {
				desc = "Close current buffer",
			})
		end,
	},

	-- {
	-- 	"folke/todo-comments.nvim",
	-- 	optional = true,
	-- 	config = function()
	-- 		local Snacks = require("snacks")
	-- 		-- map("<leader>st", Snacks.picker.todo_comments, { desc = "Todo" })
	-- 	end,
	-- },
}
