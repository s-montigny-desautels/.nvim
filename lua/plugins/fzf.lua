return {
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local fzf = require("fzf-lua")
			fzf.setup({})

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
					fzf.git_files({ cmd = "git ls-files -co --exclude-standard" })
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
