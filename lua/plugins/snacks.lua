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
				notifier = {
					enabled = true,
					timeout = 3000,
					top_down = false,
				},
				input = {
					enabled = true,
					prompt_pos = "left",
					win = {
						relative = "cursor",
						row = 1,
						col = -2,
					},
				},
				picker = {
					main = {
						file = false,
					},
					matcher = {
						fuzzy = true,
						smartcase = true,
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
					ui_select = true,
					toggles = {
						follow = "f",
						hidden = "h",
						ignored = "i",
						modified = "m",
						regex = { icon = "R", value = false },
					},
				},
				quickfile = { enabled = true },
				statuscolumn = { enabled = false },
				words = { enabled = true },
				terminal = {},
				win = {
					position = "float",
					backdrop = 100,
					border = "rounded",
				},
			})

			map("]]", function()
				Snacks.words.jump(vim.v.count1)
			end, { mode = { "n", "t" }, desc = "Next Reference" })

			map("[[", function()
				Snacks.words.jump(-vim.v.count1)
			end, { desc = "Prev Reference", mode = { "n", "t" } })

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

			-- Finder
			map("<C-p>", function()
				if require("util").is_in_git() then
					Snacks.picker.git_files({
						-- List all tracked files, untracked files, ignore all in .gitignore and ignore deleted files
						-- cmd = 'git ls-files -co --exclude-standard | grep -vE "^$(git ls-files -d | paste -sd "|" -)$"',
						untracked = true,
					})
				else
					Snacks.picker.files({ cwd = require("util").root_dir() })
				end
			end, { desc = "Search Project Files" })

			map("<leader>pf", function()
				Snacks.picker.files({ cwd = require("util").root_dir() })
			end, { desc = "Search Files" })
			map("<leader>pc", function()
				Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "Search Config File" })

			map("<leader>pw", Snacks.picker.grep_word, { desc = "Search by Grep", mode = { "n", "x" } })
			map("<leader>pg", Snacks.picker.grep, { desc = "Search by Grep" })
			map("<leader>pr", Snacks.picker.resume, { desc = "Resume" })
			map("<leader>:", Snacks.picker.command_history, { desc = "Command History" })
			map("<leader>/", Snacks.picker.grep_buffers, { desc = "[/] Fuzzily search buffers" })
			map("<leader>pb", Snacks.picker.buffers, { desc = "Search Buffers" })
			map("<leader>gs", Snacks.picker.git_status, { desc = "Git Status" })
			map("<leader>gS", Snacks.picker.git_stash, { desc = "Git Stash" })
			map("<leader>gb", Snacks.picker.git_branches, { desc = "Git Status" })
			map("<leader>gl", Snacks.picker.git_log, { desc = "Git Status" })
			map("<leader>gL", Snacks.picker.git_log_line, { desc = "Git Log Line" })
			map("<leader>gf", Snacks.picker.git_log_file, { desc = "Git Log File" })
			map("<leader>ph", Snacks.picker.help, { desc = "Search Help" })
			map("<leader>pk", Snacks.picker.keymaps, { desc = "Search Keymaps" })

			-- LSP
			map("gd", Snacks.picker.lsp_definitions, { desc = "Goto Definition" })
			map("gD", Snacks.picker.lsp_declarations, { desc = "Goto Declaration" })
			map("gr", Snacks.picker.lsp_references, { desc = "Goto References" })
			map("gI", Snacks.picker.lsp_implementations, { desc = "Goto Implementation" })
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
