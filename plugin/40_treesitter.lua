Config.now_if_args(function()
	Config.on_packchanged(
		"nvim-treesitter",
		{ "update" },
		function() vim.cmd("TSUpdate") end,
		":TSUpdate"
	)

	vim.pack.add({
		Config.gh("nvim-treesitter/nvim-treesitter"),
		Config.gh("nvim-treesitter/nvim-treesitter-textobjects"),
	})

	local languages = {
		"lua",
		"c",
		"bash",
		"vimdoc",
		"markdown",
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
		"sql",
	}

	require("nvim-treesitter").install(languages)
	require("nvim-treesitter-textobjects").setup({
		select = {
			lookahead = true,
		},
		move = {
			set_jumps = true,
		},
	})

	local treesitter = require("nvim-treesitter")
	local ts_config = require("nvim-treesitter.config")

	-- Enable treesitter on file open
	Config.new_autocmd("FileType", "*", function(event)
		local bufnr = event.buf
		local filetype = event.match

		if filetype == "" then return end

		-- Check if there is a language available for this filetype
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

		-- Install and start
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
	end, "Enable Treesitter")

	-- TODO: Move keymaps to keymaps file

	local select = require("nvim-treesitter-textobjects.select")
	local move = require("nvim-treesitter-textobjects.move")

	vim.keymap.set(
		{ "x", "o" },
		"af",
		function() select.select_textobject("@function.outer", "textobjects") end
	)
	vim.keymap.set(
		{ "x", "o" },
		"if",
		function() select.select_textobject("@function.inner", "textobjects") end
	)
	vim.keymap.set(
		{ "x", "o" },
		"ac",
		function() select.select_textobject("@class.outer", "textobjects") end
	)
	vim.keymap.set(
		{ "x", "o" },
		"ic",
		function() select.select_textobject("@class.inner", "textobjects") end
	)

	vim.keymap.set(
		{ "x", "o" },
		"id",
		function() select.select_textobject("@conditional.inner", "textobjects") end
	)
	vim.keymap.set(
		{ "x", "o" },
		"ad",
		function() select.select_textobject("@conditional.outer", "textobjects") end
	)

	vim.keymap.set(
		{ "n", "x", "o" },
		"]f",
		function() move.goto_next_start("@function.outer", "textobjects") end
	)
	vim.keymap.set(
		{ "n", "x", "o" },
		"[f",
		function() move.goto_previous_start("@function.outer", "textobjects") end
	)

	vim.keymap.set(
		{ "n", "x", "o" },
		"]c",
		function() move.goto_next_start("@class.outer", "textobjects") end
	)
	vim.keymap.set(
		{ "n", "x", "o" },
		"[c",
		function() move.goto_previous_start("@class.outer", "textobjects") end
	)

	vim.keymap.set(
		{ "n", "x", "o" },
		"]i",
		function() move.goto_next_start("@conditional.outer", "textobjects") end
	)
	vim.keymap.set(
		{ "n", "x", "o" },
		"[i",
		function() move.goto_previous_start("@conditonal.outer", "textobjects") end
	)
end)
