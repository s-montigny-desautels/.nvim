local find_vue_path = function()
	local registry = require("mason-registry")

	return registry.get_package("vue-language-server"):get_install_path() .. "/node_modules/@vue/language-server"
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

		lua_ls = {
			Lua = {
				diagnostics = {
					disable = { "missing-field" },
				},
			},
		},
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
				"goimports",
				"gofumpt",
			}

			vim.list_extend(ensure_installed, servers_to_install)
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			-- Setup all servers
			local lspconfig = require("lspconfig")

			local default_config = {
				capabilities = capabilities,
				handlers = {
					-- Silence the `No Information Available` message
					["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
						silent = true,
					}),
				},
			}

			local setup_handlers = {
				function(name)
					lspconfig[name].setup(default_config)
				end,
			}

			for name, config in pairs(servers) do
				config = vim.tbl_deep_extend("force", {}, default_config, config)

				setup_handlers[name] = function()
					lspconfig[name].setup(config)
				end
			end

			require("mason-lspconfig").setup_handlers(setup_handlers)

			local handler = vim.lsp.handlers["textDocument/documentHighlight"]
			vim.lsp.handlers["textDocument/documentHighlight"] = function(err, result, ctx, config)
				if not vim.api.nvim_buf_is_loaded(ctx.bufnr) then
					return
				end

				vim.lsp.buf.clear_references()
				return handler(err, result, ctx, config)
			end

			-- I hate this.
			vim.lsp.inlay_hint.enable(false)

			require("plugins.lsp.bootstrap").setup()
			-- vim.api.nvim_create_autocmd("LspAttach", {
			-- 	callback = function(args)
			-- 	end,
			-- })
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
	{
		"linux-cultist/venv-selector.nvim",
		branch = "regexp",
		config = function()
			require("venv-selector").setup()
			vim.keymap.set("n", "<leader>cv", "<cmd>:VenvSelect<CR>", { desc = "Seelct VirtualEnv" })
		end,
	},
}
