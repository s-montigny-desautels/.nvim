return {
	{
		"nvim-mini/mini.nvim",
		version = false,
		lazy = false,
		config = function()
			require("mini.ai").setup()
			require("mini.surround").setup()
			require("mini.git").setup({})

			require("mini.diff").setup({
				view = {
					style = "number", -- Or sign, let's try number for now
					signs = { add = "+", change = "~", delete = "-" },
				},
			})

			vim.keymap.set("n", "<leader>gd", function()
				MiniDiff.toggle_overlay(vim.api.nvim_get_current_buf())
			end)

			-- require("mini.files").setup({
			-- 	options = {
			-- 		use_as_default_explorer = true,
			-- 	},
			-- })
			--

			local filename = "%f%m%r" -- f: relative, m: modified flag, r: readonly flag
			local location = "%l:%L"
			require("mini.statusline").setup({
				content = {
					use_icons = false,
					active = function()
						local _, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
						local git = MiniStatusline.section_git({})
						local diff = MiniStatusline.section_diff({})

						local diagnostics = MiniStatusline.section_diagnostics({})

						local search = MiniStatusline.section_searchcount({})

						return MiniStatusline.combine_groups({
							{ hl = mode_hl, strings = { git } },
							"%<",
							{ hl = "MiniStatuslineFilename", strings = { filename } },
							"%=",
							{ hl = "", strings = { diff, diagnostics } },
							{ hl = "", strings = { search, location } },
						})
					end,

					inactive = function()
						local diff = MiniStatusline.section_diff({})

						local diagnostics = MiniStatusline.section_diagnostics({})

						return MiniStatusline.combine_groups({
							{ hl = "MiniStatuslineInactive", strings = { filename } },
							"%=",
							{ strings = { diff, diagnostics } },
							{ strings = { location } },
						})
					end,
				},
			})

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

			require("mini.pick").setup({
				window = {
					config = function()
						local height = math.floor(0.618 * vim.o.lines)
						local width = math.floor(0.618 * vim.o.columns)
						return {
							anchor = "NW",
							height = height,
							width = width,
							row = math.floor(0.5 * (vim.o.lines - height)),
							col = math.floor(0.5 * (vim.o.columns - width)),
						}
					end,
				},
			})
			require("mini.extra").setup()

			-- Common
			vim.keymap.set("n", "<C-p>", function()
				MiniPick.builtin.files({
					tool = "rg",
				})
			end)
			vim.keymap.set("n", "<leader>pb", function()
				MiniPick.builtin.buffers()
			end)
			vim.keymap.set("n", "<leader>ph", function()
				MiniPick.builtin.help()
			end)
			vim.keymap.set("n", "<leader>pr", function()
				MiniPick.builtin.resume()
			end)
			vim.keymap.set("n", "<leader>pg", function()
				MiniPick.builtin.grep_live()
			end)
			vim.keymap.set({ "n", "v" }, "<leader>pw", function()
				local word

				if vim.fn.mode() == "v" then
					-- Save the selection in a register
					local saved_reg = vim.fn.getreg("v")
					vim.cmd([[noautocmd sil norm "vy]])
					local selection = vim.fn.getreg("v")
					vim.fn.setreg("v", saved_reg)

					word = selection
				else
					word = vim.fn.expand("<cword>")
				end

				-- Need to schedule, since picker open is async
				vim.schedule(function()
					MiniPick.set_picker_query({ word })
				end)
				MiniPick.builtin.grep_live()
			end)

			-- LSP
			vim.keymap.set("n", "gd", function()
				MiniExtra.pickers.lsp({
					scope = "definition",
				})
			end)
			vim.keymap.set("n", "gD", function()
				MiniExtra.pickers.lsp({
					scope = "declaration",
				})
			end)
			vim.keymap.set("n", "gr", function()
				MiniExtra.pickers.lsp({
					scope = "references",
				})
			end)
			vim.keymap.set("n", "gI", function()
				MiniExtra.pickers.lsp({
					scope = "implementation",
				})
			end)

			-- GIT
			vim.keymap.set("n", "<leader>gs", function()
				MiniExtra.pickers.git_files({
					scope = "modified",
				})
			end)
			vim.keymap.set("n", "<leader>gb", function()
				MiniExtra.pickers.git_branches()
			end)
			vim.keymap.set("n", "<leader>gc", function()
				MiniExtra.pickers.git_commits()
			end)
			vim.keymap.set("n", "<leader>gl", function()
				MiniExtra.pickers.git_commits({ path = vim.fn.expand("%:p") })
			end)

			local hipatterns = require("mini.hipatterns")
			local hi_words = MiniExtra.gen_highlighter.words
			hipatterns.setup({
				highlighters = {
					fixme = hi_words({ "FIXME" }, "MiniHipatternsFixme"),
					hack = hi_words({ "HACK" }, "MiniHipatternsHack"),
					todo = hi_words({ "TODO" }, "MiniHipatternsTodo"),
					note = hi_words({ "NOTE" }, "MiniHipatternsNote"),

					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			})

			local miniclue = require("mini.clue")
			miniclue.setup({
				window = {
					delay = 400,
				},
				triggers = {
					-- Leader triggers
					{ mode = { "n", "x" }, keys = "<Leader>" },

					-- `[` and `]` keys
					{ mode = "n", keys = "[" },
					{ mode = "n", keys = "]" },

					-- Built-in completion
					{ mode = "i", keys = "<C-x>" },

					-- `g` key
					{ mode = { "n", "x" }, keys = "g" },

					-- Marks
					{ mode = { "n", "x" }, keys = "'" },
					{ mode = { "n", "x" }, keys = "`" },

					-- Registers
					{ mode = { "n", "x" }, keys = '"' },
					{ mode = { "i", "c" }, keys = "<C-r>" },

					-- Window commands
					{ mode = "n", keys = "<C-w>" },

					-- `z` key
					{ mode = { "n", "x" }, keys = "z" },
				},

				clues = {
					-- Enhance this by adding descriptions for <Leader> mapping groups
					miniclue.gen_clues.square_brackets(),
					miniclue.gen_clues.builtin_completion(),
					miniclue.gen_clues.g(),
					miniclue.gen_clues.marks(),
					miniclue.gen_clues.registers(),
					miniclue.gen_clues.windows(),
					miniclue.gen_clues.z(),
				},
			})
		end,
	},
}
