return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		branch = "main",
		dependencies = {
			{
				{
					"nvim-treesitter/nvim-treesitter-textobjects",
					branch = "main",
				},
			},
		},
		config = function()
			require("nvim-treesitter").install({
				"c",
				"bash",
				"lua",
				"vim",
				"vimdoc",
				"markdown",
				"query",
				"go",
				"gomod",
				"gowork",
				"gosum",
				"javascript",
				"typescript",
				"json",
				"json5",
				"dockerfile",
				"vue",
				"html",
				"css",
			})

			local treesitter = require("nvim-treesitter")
			local ts_config = require("nvim-treesitter.config")

			vim.api.nvim_create_autocmd({ "FileType" }, {
				desc = "Enable Treesitter",
				callback = function(event)
					local bufnr = event.buf
					local filetype = event.match

					if filetype == "" then
						return
					end

					local parser_name = vim.treesitter.language.get_lang(filetype)
					if not parser_name then
						vim.notify(
							vim.inspect("No treesitter parser found for filetype: " .. filetype),
							vim.log.levels.WARN
						)
						return
					end

					if not vim.tbl_contains(ts_config.get_available(), parser_name) then
						return
					end

					treesitter.install({ parser_name }):await(function()
						local hasStarted = pcall(vim.treesitter.start, bufnr, parser_name)

						if hasStarted then
							if parser_name == "vue" then
								vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
							end

							vim.wo.foldmethod = "expr"
							vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
						end
					end)
				end,
			})

			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
				},
				move = {
					set_jumps = true,
				},
			})

			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")

			vim.keymap.set({ "x", "o" }, "af", function()
				select.select_textobject("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "if", function()
				select.select_textobject("@function.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ac", function()
				select.select_textobject("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ic", function()
				select.select_textobject("@class.inner", "textobjects")
			end)

			vim.keymap.set({ "x", "o" }, "id", function()
				select.select_textobject("@conditional.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ad", function()
				select.select_textobject("@conditional.outer", "textobjects")
			end)

			vim.keymap.set({ "n", "x", "o" }, "]f", function()
				move.goto_next_start("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[f", function()
				move.goto_previous_start("@function.outer", "textobjects")
			end)

			vim.keymap.set({ "n", "x", "o" }, "]c", function()
				move.goto_next_start("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[c", function()
				move.goto_previous_start("@class.outer", "textobjects")
			end)

			vim.keymap.set({ "n", "x", "o" }, "]i", function()
				move.goto_next_start("@conditional.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[i", function()
				move.goto_previous_start("@conditonal.outer", "textobjects")
			end)
		end,
	},
}
