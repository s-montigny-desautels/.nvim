local find_vue_path = function()
	local registry = require("mason-registry")

	return registry.get_package("vue-language-server"):get_install_path() .. "/node_modules/@vue/language-server"
end

local function set_keymap(args)
	local conform = require("conform")
	local buf = args.buf

	local function map(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = buf, desc = "LSP: " .. desc })
	end

	require("which-key").register({ name = "[C]ode", _ = "which_key_ignore" })

	map("<leader>cf", function()
		conform.format({ async = true, lsp_fallback = true })
	end, "[F]ormat buffer")

	local builtin = require("telescope.builtin")

	map("gd", function()
		builtin.lsp_definitions({ reuse_win = true })
	end, "[G]oto [D]efinition")

	map("gr", builtin.lsp_references, "[G]oto [R]eferences")
	map("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")

	map("K", vim.lsp.buf.hover, "Hover Documentation")

	vim.keymap.set("n", "<leader>cr", function()
		return ":IncRename " .. vim.fn.expand("<cword>")
	end, { desc = "[C]ode [R]ename", expr = true })

	map("<leader>ca", function()
		vim.lsp.buf.code_action({
			context = {
				only = {
					"source",
				},
				diagnostics = {},
			},
		})
	end, "[C]ode [A]ction")
end

local function lsp_support_method(args, method)
	local client = vim.lsp.get_client_by_id(args.data.client_id)
	if client == nil or not client.supports_method(method, { bufnr = args.buf }) then
		return false
	end

	return true
end

local function codelens(args)
	local buf = args.buf

	if not lsp_support_method(args, "textDocument/codeLens") then
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
end

local function cursor_highlight(args)
	local buf = args.buf

	if not lsp_support_method(args, "textDocument/documentHighlight") then
		return
	end

	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" }, {
		group = vim.api.nvim_create_augroup("lsp_word_" .. buf, { clear = true }),
		buffer = buf,
		callback = function(ev)
			if ev.event:find("CursorMoved") then
				vim.lsp.buf.clear_references()
			else
				vim.lsp.buf.document_highlight()
			end
		end,
	})
end

local function server_settings()
	local lspconfig = require("lspconfig")
	local git_root_dir = lspconfig.util.root_pattern(".git")
	local ok, vue_language_server_path = pcall(find_vue_path)
	if not ok then
		vue_language_server_path = ""
	end

	return {
		gopls = {
			settings = {
				gopls = {
					usePlaceholders = false,
					analyses = {
						fieldalignment = false,
					},
				},
			},
		},

		pyright = {
			settings = {
				python = {
					analysis = {
						reportUnusedImport = "none",
						reportUnusedClass = "none",
						reportUnusedFunction = "none",
						reportUnusedVariable = "none",
					},
				},
			},
		},

		volar = {
			root_dir = git_root_dir,
			init_options = {
				vue = {
					hybridMode = true,
				},
			},
		},
		tsserver = {
			root_dir = git_root_dir,
			implicitProjectConfiguration = {
				checkJs = true,
			},
			init_options = {
				preferences = {
					importModuleSpecifierPreference = "relative",
					importModuleSpecifierEnding = "minimal",
				},
				plugins = {
					{
						name = "@vue/typescript-plugin",
						location = vue_language_server_path,
						languages = { "vue" },
					},
				},
			},
			filetypes = {
				"typescript",
				"typescriptreact",
				"javascript",
				"javascriptreact",
				"vue",
			},
		},

		jsonls = {
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
				},
			},
		},

		yamlls = {
			settings = {
				yaml = {
					schemaStore = {
						enable = false,
						url = "",
					},
					schemas = require("schemastore").yaml.schemas(),
				},
			},
		},

		lua_ls = {},
	}
end

return {
	-- Better LSP rename
	{
		"smjonas/inc-rename.nvim",
		config = function()
			require("inc_rename").setup({})
		end,
	},

	-- LSP task progress
	{
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({
				notification = {
					window = {
						winblend = 0,
					},
				},
			})
		end,
	},

	-- LSP setup
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "folke/neodev.nvim", opts = {} },
			"b0o/SchemaStore.nvim",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			local servers = server_settings()

			local servers_to_install = vim.tbl_keys(servers)

			local ensure_installed = {
				"stylua",
				"lua_ls",
				"tailwindcss-language-server",
				"prettierd",
				"black",
			}

			vim.list_extend(ensure_installed, servers_to_install)
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			-- Setup all servers
			local lspconfig = require("lspconfig")
			for name, config in pairs(servers) do
				config = vim.tbl_deep_extend("force", {}, {
					capabilities = capabilities,
					handlers = {
						-- Silence the `No Information Available` message
						["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
							silent = true,
						}),
					},
				}, config)

				lspconfig[name].setup(config)
			end

			local highlightHandler = vim.lsp.handlers["textDocument/documentHighlight"]
			vim.lsp.handlers["textDocument/documentHighlight"] = function(err, result, ctx, config)
				if not vim.api.nvim_buf_is_loaded(ctx.bufnr) then
					return
				end
				return highlightHandler(err, result, ctx, config)
			end

			-- I hate this.
			vim.lsp.inlay_hint.enable(false)

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					set_keymap(args)
					codelens(args)
					cursor_highlight(args)
				end,
			})
		end,
	},

	-- Setup formatter
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					sql = { "sql_formatter" },
					templ = { "templ" },
					c = { "clang-format" },
					go = { "goimports", "gofumpt" },
					python = { "black" },
					javascript = { "prettierd" },
					javascriptreact = { "prettierd" },
					typescript = { "prettierd" },
					typescriptreact = { "prettierd" },
					vue = { "prettierd" },
					css = { "prettierd" },
					scss = { "prettierd" },
					less = { "prettierd" },
					html = { "prettierd" },
					json = { "prettierd" },
					jsonc = { "prettierd" },
					yaml = { "prettierd" },
					markdown = { "prettierd" },
					["markdown.mdx"] = { "prettierd" },
					graphql = { "prettierd" },
					handlebars = { "prettierd" },
				},
			})
		end,
	},
}
