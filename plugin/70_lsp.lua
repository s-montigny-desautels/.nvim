local add, later, on_filetype, gh =
	Config.add, Config.later, Config.on_filetype, Config.gh

on_filetype("lua", function()
	add({ gh("folke/lazydev.nvim") })

	require("lazydev").setup()
end)

later(function()
	add({
		gh("mason-org/mason.nvim"),
		gh("mason-org/mason-lspconfig.nvim"),
		gh("neovim/nvim-lspconfig"),
		gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
		gh("b0o/SchemaStore.nvim"),
	})

	require("mason").setup()
	require("mason-lspconfig").setup()
	require("mason-tool-installer").setup({
		ensure_installed = {
			-- Go
			"gopls",
			"gofumpt",
			"goimports",

			-- Web
			"vue_ls",
			"vtsls",
			"tailwindcss",
			"jsonls",
			"yamlls",
			"css-lsp",
			"eslint_d",
			"html_lsp",
			"prettierd",

			-- Other
			"lua_ls",
			"terraform-ls",
		},
	})

	vim.lsp.inlay_hint.enable(false)

	local lsp_hightlight_available = function(buf)
		local clients = vim.lsp.get_clients({
			bufnr = buf,
			method = "textDocument/documentHighlight",
		})
		return #clients > 0
	end

	Config.new_autocmd({ "CursorHold", "CursorHoldI" }, "*", function(args)
		if not lsp_hightlight_available(args.buf) then return end

		vim.lsp.buf.document_highlight()
	end)

	Config.new_autocmd({ "CursorMoved" }, "*", function(args)
		if not lsp_hightlight_available(args.buf) then return end

		vim.lsp.buf.clear_references()
	end)

	Config.new_autocmd("LspAttach", "*", function(args)
		local buf = args.buf

		local function map(keys, func, desc, mode)
			if mode == nil then mode = "n" end
			vim.keymap.set(
				mode,
				keys,
				func,
				{ buffer = buf, desc = "LSP: " .. desc }
			)
		end

		map(
			"K",
			function() vim.lsp.buf.hover({ silent = true }) end,
			"Hover Documentation"
		)

		map("<leader>cr", function() vim.lsp.buf.rename() end, "[C]ode [R]ename")

		map(
			"<leader>cA",
			function() vim.lsp.buf.code_action() end,
			"[C]ode [A]ction line or selection",
			{ "n", "x" }
		)

		map(
			"<leader>ca",
			function()
				vim.lsp.buf.code_action({
					context = {
						only = { "source" },
						diagnostics = {},
					},
				})
			end,
			"[C]ode [A]ction file",
			{ "n", "x" }
		)

		map("<leader>clr", function() vim.cmd("lsp restart") end, "[L]sp [R]estart")

		-- TODO This is not working, debug when needed again...
		-- map("<leader>cc", function()
		-- 	local params = {
		-- 		textDocument = vim.lsp.util.make_text_document_params(buf),
		-- 	}
		-- 	local result = vim.lsp.buf_request_sync(buf, "textDocument/codeLens", params, 3000)
		--
		-- 	local codeLens = {}
		-- 	local empty = true
		--
		-- 	for _, res in pairs(result or {}) do
		-- 		for _, r in pairs(res.result or {}) do
		-- 			table.insert(codeLens, r)
		-- 			empty = false
		-- 		end
		-- 	end
		--
		-- 	if empty then
		-- 		vim.notify("No codelens available", "info")
		-- 		return
		-- 	end
		--
		-- 	vim.ui.select(codeLens, {
		-- 		prompt = "Select code lens",
		-- 		format_item = function(item)
		-- 			return item.command.title .. " (line " .. item.range.start.line .. ")"
		-- 		end,
		-- 	}, function(selected)
		-- 		if not selected then
		-- 			return
		-- 		end
		-- 		vim.lsp.buf_request_sync(buf, "workspace/executeCommand", selected.command, 3000)
		-- 	end)
		-- end, "Code Lens")
	end)
end)

later(function()
	add({ gh("stevearc/conform.nvim") })

	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			sql = { "pg_format" },
			go = { "goimports", "gofumpt" },
			javascript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescript = { "deno_fmt", "prettierd" },
			typescriptreact = { "prettierd" },
			vue = { "prettierd" },
			css = { "prettierd" },
			html = { "prettierd" },
			json = { "prettierd" },
			jsonc = { "prettierd" },
			yaml = { "prettierd" },
			markdown = { "prettierd" },
			["markdown.mdx"] = { "prettierd" },
		},
		formatters = {
			pg_format = {
				append_args = function()
					return {
						"-t",
						"--no-space-function",
						"--keep-newline",
						"--comma-break",
						"--comma-start",
					}
				end,
			},
		},
	})

	vim.keymap.set(
		"n",
		"<leader>cf",
		function() require("conform").format({ async = true, lsp_fallback = true }) end,
		{ desc = "LSP: " .. "[F]ormat buffer" }
	)
end)

later(function()
	add({
		{ src = gh("saghen/blink.cmp"), version = vim.version.range("*") },
		gh("rafamadriz/friendly-snippets"),
	})

	local function split(inputstr, sep)
		if sep == nil then sep = "%s" end
		local t = {}
		for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
			table.insert(t, str)
		end
		return t
	end

	require("blink.cmp").setup({
		keymap = {
			preset = "default",
		},
		sources = {
			default = { "lsp", "buffer", "snippets", "path" },

			per_filetype = {
				lua = { inherit_defaults = true, "lazydev" },
			},

			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
				lsp = {
					transform_items = function(_, items)
						if vim.bo.filetype ~= "vue" then return items end

						for _, item in ipairs(items) do
							if
								item.textEdit
								and string.find(item.textEdit.newText, '.+="$1"')
								and not string.match(item.textEdit.newText, "^:")
							then
								item.textEdit.newText =
									split(item.textEdit.newText, "=")[1]
							end

							return items
						end
					end,
				},
			},
		},

		completion = {
			keyword = { range = "full" },
			accept = { auto_brackets = { enabled = false } },
			trigger = {
				show_on_insert_on_trigger_character = false,
			},
			menu = {
				border = "single",
				draw = {
					treesitter = { "lsp" },
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
				window = {
					border = "single",
				},
			},
		},

		signature = {
			enabled = true,
			trigger = {
				enabled = false,
			},
			window = {
				border = "single",
			},
		},
	})
end)

later(function()
	add({ gh("folke/trouble.nvim") })

	local trouble = require("trouble")
	trouble.setup({
		modes = { lsp = { win = { position = "right" } } },
	})

	-- TODO: Move to keymap file
	local function map(key, func, desc)
		vim.keymap.set("n", key, func, { desc = desc })
	end

	map(
		"<leader>xx",
		"<cmd>Trouble diagnostics toggle<CR>",
		"Workspace Diagnostics (Trouble)"
	)
	map("[q", function()
		if trouble.is_open() then
			---@diagnostic disable-next-line: missing-parameter
			trouble.prev()
		else
			local ok, err = pcall(vim.cmd.cprev)
			if not ok then vim.notify(err, vim.log.levels.ERROR) end
		end
	end, "Previous Trouble/Quickfix Item")

	map("]q", function()
		if trouble.is_open() then
			---@diagnostic disable-next-line: missing-parameter
			trouble.next()
		else
			local ok, err = pcall(vim.cmd.cnext)
			if not ok then vim.notify(err, vim.log.levels.ERROR) end
		end
	end, "Next Trouble/Quickfix Item")
end)
