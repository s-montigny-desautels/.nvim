Config.new_autocmd(
	"ColorScheme",
	"*",
	function()
		vim.cmd([[
			highlight link @lsp.type.component @type
		]])
	end
)

Config.new_autocmd(
	"TextYankPost",
	"*",
	function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
	"Highlight when yanking text"
)

Config.new_autocmd("FileType", "help", function() vim.cmd("wincmd L") end)

Config.new_autocmd(
	"User",
	"PersistenceLoadPost",
	Config.buffer.close_unamed,
	"Remove no-neck-pain buffers on session restore"
)

Config.new_autocmd(
	"FileType",
	{ "json", "jsonc", "json5" },
	function() vim.opt_local.conceallevel = 0 end,
	"Fix conceallevel fro json files"
)

Config.new_autocmd({ "BufLeave", "FocusLost" }, "*", function(args)
	local buf = args.buf

	if
		vim.bo[buf].modified
		and vim.bo[buf].buftype == ""
		and vim.bo[buf].filetype ~= ""
	then
		vim.api.nvim_buf_call(args.buf, function() vim.cmd("silent! update") end)
	end
end, "Save buffers on leave")

Config.new_autocmd({ "InsertLeave", "WinEnter" }, "*", function()
	local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
	if ok and cl then
		vim.wo.cursorline = true
		vim.api.nvim_win_del_var(0, "auto-cursorline")
	end
end, "Show cursor line one win load")

Config.new_autocmd({ "InsertEnter", "WinLeave" }, "*", function()
	local cl = vim.wo.cursorline
	if cl then
		vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
		vim.wo.cursorline = false
	end
end, "Hide cursor line on inactive buffer or when in insert mode")

Config.new_autocmd("FileType", {
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
}, function(event)
	vim.bo[event.buf].buflisted = false
	vim.keymap.set("n", "q", "<cmd>close<cr>", {
		buffer = event.buf,
		silent = true,
		desc = "Quit buffer",
	})
end, "Close some filetypes with <q>")

Config.new_autocmd(
	"CmdwinEnter",
	nil,
	function() vim.keymap.set("n", "<esc>", ":quit<CR>", { buffer = true }) end
)
