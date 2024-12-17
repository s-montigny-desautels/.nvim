vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	callback = function()
		vim.highlight.on_yank()
	end,
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
		if args.file == nil or args.file == "" then
			return
		end

		if string.find(args.file, "^oil") then
			return
		end

		if string.find(args.file, "__harpoon") then
			return
		end

		if vim.api.nvim_buf_get_option(args.buf, "modified") then
			vim.api.nvim_buf_call(args.buf, function()
				vim.cmd("silent! write")
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

-- gopls cgo generate
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local buf = ev.buf

		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client ~= nil and not client.supports_method("textDocument/codeLens", { bufnr = buf }) then
			return
		end

		vim.keymap.set("n", "<leader>cc", function()
			local params = {
				textDocument = vim.lsp.util.make_text_document_params(buf),
			}
			local result = vim.lsp.buf_request_sync(buf, "textDocument/codeLens", params, 3000)

			local codeLens = {}

			for _, res in pairs(result or {}) do
				for _, r in pairs(res.result or {}) do
					table.insert(codeLens, r)
				end
			end

			vim.ui.select(codeLens, {
				prompt = "Select code lens",
				format_item = function(item)
					return item.command.title .. " (line " .. item.range.start.line .. ")"
				end,
			}, function(selected)
				if not selected then
					return
				end
				vim.lsp.buf_request_sync(buf, "workspace/executeCommand", selected.command, 3000)
			end)
		end, {
			desc = "Code Lens",
			buffer = buf,
		})
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
