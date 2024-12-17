return {
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local fzf = require("fzf-lua")

			local config = require("fzf-lua.config")

			config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
			config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
			config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"

			fzf.setup({
				fzf_colors = true,
				fzf_opts = {
					["--no-scrollbar"] = true,
				},
				defaults = {
					formatter = "path.filename_first",
				},
				winopts = {
					width = 0.8,
					height = 0.8,
					row = 0.5,
					col = 0.5,
					preview = {
						scrollchars = { "┃", "" },
						flip_columns = 160,
					},
				},
			})

			local map = function(keys, func, desc)
				vim.keymap.set("n", keys, func, { desc = desc })
			end

			require("which-key").add({
				{ "<leader>p", group = "[P]rompt" },
			})

			map("<leader>ph", fzf.helptags, "Search Help")
			map("<leader>pk", fzf.keymaps, "Search Keymaps")

			map("<leader>pf", function()
				fzf.files({
					cwd = require("util").root_dir(),
				})
			end, "Search Files")

			map("<C-p>", function()
				if require("util").is_in_git() then
					fzf.git_files({
						-- List all tracked files, untracked files, ignore all in .gitignore and ignore deleted files
						cmd = "git ls-files -co --exclude-standard | grep -vE \"^$(git ls-files -d | paste -sd \"|\" -)$\"",
					})
				else
					fzf.files({
						cwd = require("util").root_dir(),
					})
				end
			end, "Search Project Files")

			map("<leader>pw", fzf.grep_cword, "Search current Word")
			map("<leader>pg", fzf.live_grep, "Search by Grep")
			map("<leader>pr", fzf.resume, "Search Resume")
			map("<leader>:", fzf.command_history, "Command History")
			map("<leader>/", fzf.grep_curbuf, "[/] Fuzzily search in current buffer")

			map("<leader>pb", fzf.buffers, "Search Buffers")
			map("<leader>gs", fzf.git_status, "Git Status")
		end,
	},
}
