return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",

			-- Lang
			"nvim-neotest/neotest-go",
			"marilari88/neotest-vitest",
		},
		config = function()
			require("which-key").add({
				{ "<leader>t", group = "[T]est" },
			})

			local neotest = require("neotest")
			neotest.setup({
				status = { enabled = true, virtual_text = true },
				output = { enabled = true, open_on_run = true },
				quickfix = {
					enabled = true,
					open = function()
						require("trouble").open({ mode = "quickfix", focus = false })
					end,
				},
				adapters = {
					require("neotest-go"),
					require("neotest-vitest"),
				},
			})

			local map = function(keys, fn, desc)
				vim.keymap.set("n", keys, fn, { desc = desc })
			end

			map("<leader>tt", function()
				neotest.run.run(vim.fn.expand("%"))
			end, "Run File")

			map("<leader>tT", function()
				neotest.run.run(vim.uv.cwd())
			end, "Run All Test Files")

			map("<leader>tr", function()
				neotest.run.run()
			end, "Run Nearest")

			map("<leader>to", function()
				neotest.output.open({ enter = true, auto_close = true })
			end, "Show Output")

			map("<leader>ts", function()
				neotest.summary.toggle()
			end, "Toggle Summary")
		end,
	},
}
