local now, now_if_arg, later = Config.now, Config.now_if_args, Config.later

now(function()
	require("mini.icons").setup({})

	later(MiniIcons.mock_nvim_web_devicons)
	later(MiniIcons.tweak_lsp_kind)
end)

now(function()
	require("mini.notify").setup({
		lsp_progress = {
			enable = true,
		},
		window = {
			config = function()
				local has_statusline = vim.o.laststatus > 0
				local pad = vim.o.cmdheight + (has_statusline and 1 or 0)

				return {
					anchor = "SE",
					col = vim.o.columns,
					row = vim.o.lines - pad,
				}
			end,
		},
	})
end)

now(function() require("mini.sessions").setup() end)

now(function()
	require("mini.statusline").setup({
		content = {
			use_icons = false,
			active = function()
				local _, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
				local git = MiniStatusline.section_git({})

				local filename

				local buf = vim.api.nvim_get_current_buf()
				local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
				if ft == "oil" then
					filename =
						---@diagnostic disable-next-line: param-type-mismatch
						vim.fn.fnamemodify(require("oil").get_current_dir(buf), ":~")
				else
					filename = "%f%m%r" -- f: relative, m: modified flag, r: readonly flag
				end

				local diff = MiniStatusline.section_diff({})

				local diagnostics = MiniStatusline.section_diagnostics({})

				local search = MiniStatusline.section_searchcount({})
				local location = "%l:%L"

				return MiniStatusline.combine_groups({
					{ hl = mode_hl, strings = { git } },
					"%<",
					{ hl = "MiniStatuslineFilename", strings = { filename } },
					"%=",
					{ hl = "", strings = { diff, diagnostics } },
					{ hl = "", strings = { search, location } },
				})
			end,
		},
	})
end)

-- TODO: Do I like this ?
-- now(function() require("mini.tabline").setup() end)

-- TODO: To replace oil ?
-- now_if_arg(function()
-- 	require("mini.files").setup({
-- 		windows = {
-- 			preview = true,
-- 		},
-- 	})
-- 	local add_marks = function()
-- 		MiniFiles.set_bookmark("c", vim.fn.stdpath("config"), { desc = "Config" })
-- 		local vimpack_plugins = vim.fn.stdpath("data") .. "/site/pack/core/opt"
-- 		MiniFiles.set_bookmark("p", vimpack_plugins, { desc = "Plugins" })
-- 		MiniFiles.set_bookmark("w", vim.fn.getcwd, { desc = "Working directory" })
-- 	end
-- 	Config.new_autocmd("User", "MiniFilesExplorerOpen", add_marks, "Add bookmarks")
-- end)

now_if_arg(function()
	require("mini.misc").setup()

	MiniMisc.setup_auto_root()
	MiniMisc.setup_restore_cursor()
	MiniMisc.setup_termbg_sync()
end)

later(function() require("mini.ai").setup() end)

later(function() require("mini.surround") end)

later(function() require("mini.git").setup() end)

later(function()
	require("mini.diff").setup({
		view = {
			style = "sign",
			signs = { add = "+", change = "~", delete = "-" },
		},
		options = {
			wrap_goto = true,
		},
	})

	-- Config.keymap.nmap("]h", function() MiniDiff.goto_hunk("next") end, "Next Hunk")
	-- Config.keymap.nmap("[h", function() MiniDiff.goto_hunk("prev") end, "Prev Hunk")
end)

later(function() require("mini.extra").setup() end)

later(function()
	local hipatterns = require("mini.hipatterns")
	local hi_words = MiniExtra.gen_highlighter.words

	hipatterns.setup({
		highlighers = {
			fixme = hi_words({ "FIXME", "Fixme", "fixme" }, "MiniHipatternsFixme"),
			hack = hi_words({ "HACK", "Hack", "hack" }, "MiniHipatternsHack"),
			todo = hi_words({ "TODO", "Todo", "todo" }, "MiniHipatternsTodo"),
			note = hi_words({ "NOTE", "Note", "note" }, "MiniHipatternsNote"),
		},
		hex_color = hipatterns.gen_highlighter.hex_color(),
	})
end)

later(
	function()
		require("mini.indentscope").setup({
			draw = {
				delay = 0,
				animation = require("mini.indentscope").gen_animation.none(),
			},

			symbol = "│",
		})
	end
)
