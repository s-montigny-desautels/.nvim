vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.cmd([[
			highlight link @lsp.type.component @type
		]])
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

-- Open help in split
vim.api.nvim_create_autocmd("FileType", {
	pattern = "help",
	command = "wincmd L",
})

vim.api.nvim_create_autocmd("User", {
	pattern = "PersistenceLoadPost",
	callback = function()
		require("buffer").close_unamed()
	end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "json", "jsonc", "json5" },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
	callback = function(args)
		local buf = args.buf

		if vim.bo[buf].modified and vim.bo[buf].buftype == "" and vim.bo[buf].filetype ~= "" then
			vim.api.nvim_buf_call(args.buf, function()
				vim.cmd("silent! update")
			end)
		end
	end,
})

-- show cursor line only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
	callback = function()
		local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
		if ok and cl then
			vim.wo.cursorline = true
			vim.api.nvim_win_del_var(0, "auto-cursorline")
		end
	end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
	callback = function()
		local cl = vim.wo.cursorline
		if cl then
			vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
			vim.wo.cursorline = false
		end
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"help",
		"lspinfo",
		"qf",
		"spectre_panel",
		"startuptime",
		"neotest-output",
		"checkhealth",
		"neotest-summary",
		"neotest-output-panel",
		"gitsigns.blame",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", {
			buffer = event.buf,
			silent = true,
			desc = "Quit buffer",
		})
	end,
})
