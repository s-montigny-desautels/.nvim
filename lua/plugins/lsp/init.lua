local function server_settings()
	local vue_language_server_path = vim.fn.stdpath("data")
		.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

	return {
		gopls = {
			settings = {
				gopls = {
					buildFlags = { "-tags=tools" },
					usePlaceholders = false,
					completeFunctionCalls = false,
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

		tailwindcss = {
			settings = {
				tailwindCSS = {
					classAttributes = {
						"class",
						"className",
						"ngClass",
						"activeClass",
						"exactActiveClass",
						"enterActiveClass",
						"enterFromClass",
						"enterToClass",
						"leaveActiveClass",
						"leaveFromClass",
						"leaveToClass",
						"innerClass",
						"inner-class",
					},
					experimental = {
						classRegex = {
							"tw`([^`]*)`",
							{ "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
							{ "cva\\(((?:[^()]|\\([^()]*\\))*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
							{ "cx\\(((?:[^()]|\\([^()]*\\))*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
						},
					},
				},
			},
		},

		vue_ls = {
			on_init = function(client)
				client.handlers["tsserver/request"] = function(_, result, context)
					local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
					if #clients == 0 then
						vim.notify(
							"Could not found `vtsls` lsp client, vue_lsp would not work without it.",
							vim.log.levels.ERROR
						)
						return
					end

					local ts_client = clients[1]

					local param = unpack(result)
					local id, command, payload = unpack(param)
					ts_client:exec_cmd({
						command = "typescript.tsserverRequest",
						arguments = {
							command,
							payload,
						},
					}, { bufnr = context.bufnr }, function(err, res)
						if err then
							vim.notify("vtsls error: " .. vim.inspect(err), vim.log.levels.ERROR)
							return
						end
						if not res or not res.body then
							vim.notify(("vtsls returned no data for %s"):format(command), vim.log.levels.WARN)
							return
						end

						client:notify("tsserver/response", { { id, res.body } })
					end)
				end
			end,
			-- init_options = {
			-- 	vue = {
			-- 		hybridMode = true,
			-- 	},
			-- },
			settings = {
				vue = {
					complete = {
						casing = {
							props = "camel",
							tags = "pascal",
						},
					},
				},
			},
		},

		denols = {
			-- root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc", ".git"),
			root_markers = { "deno.json", "deno.jsonc" },
			workspace_required = true,
			single_file_support = false,
		},

		vtsls = {
			root_markers = { "package.json" },
			-- init_options = {
			-- 	plugins = {
			-- 		{
			-- 			name = "@vue/typescript-plugin",
			-- 			location = vue_language_server_path,
			-- 			languages = { "vue" },
			-- 			configNamespace = "typescript",
			-- 		},
			-- 	},
			-- },
			workspace_required = true,
			single_file_support = false,
			filetypes = {
				"typescript",
				"typescriptreact",
				"javascript",
				"javascriptreact",
				"vue",
			},
			settings = {
				complete_function_calls = false,
				vtsls = {
					enableMoveToFileCodeAction = true,
					autoUseWorkspaceTsdk = true,
					experimental = {
						completion = {
							enableServerSideFuzzyMatch = true,
						},
					},
					tsserver = {
						globalPlugins = {
							{
								name = "@vue/typescript-plugin",
								location = vue_language_server_path,
								languages = { "vue" },
								configNamespace = "typescript",
								enableForWorkspaceTypeScriptVersions = true,
							},
						},
					},
				},
				typescript = {
					updateImportsOnFileMove = { enabled = "always" },
					suggest = {
						completeFunctionCalls = false,
					},
					preferences = {
						importModuleSpecifier = "project-relative",
					},
					inlayHints = {
						enumMemberValues = { enabled = true },
						functionLikeReturnTypes = { enabled = true },
						parameterNames = { enabled = "literals" },
						parameterTypes = { enabled = true },
						propertyDeclarationTypes = { enabled = true },
						variableTypes = { enabled = false },
					},
				},
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

		cssls = {
			settings = {
				css = { validate = false },
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

	-- -- LSP task progress
	-- {
	-- 	"j-hui/fidget.nvim",
	-- 	config = function()
	-- 		require("fidget").setup({
	-- 			notification = {
	-- 				window = {
	-- 					winblend = 0,
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },

	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					border = "rounded",
				},
			})

			vim.keymap.set("n", "<leader>lm", "<cmd>Mason<CR>", { desc = "Open mason" })
		end,
	},

	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {},
	},

	{
		"artemave/workspace-diagnostics.nvim",
		opts = {},
	},

	-- LSP setup
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			-- "WhoIsSethDaniel/mason-tool-installer.nvim",
			"b0o/SchemaStore.nvim",
			{
				"nvim-flutter/flutter-tools.nvim",
				config = function()
					require("flutter-tools").setup({})
				end,
			},
		},
		config = function()
			require("which-key").add({
				{ "<leader>c", group = "[C]ode" },
				{ "<leader>cl", group = "[C]ode [L]sp" },
			})

			local servers = server_settings()

			require("mason-lspconfig").setup({
				automatic_enable = true,
			})

			vim.lsp.config("*", {
				handlers = {
					-- Silence the `No Information Available` message
					["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
						silent = true,
					}),
				},
			})

			for name, config in pairs(servers) do
				vim.lsp.config(name, config)
			end

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
		end,
	},

	-- Setup formatter
	{
		"stevearc/conform.nvim",
		config = function()
			---Return true if the buf as a LSP client with the given name attached.
			---@param buf integer
			---@param clientsName string[]
			---@return boolean
			local function enableIfClients(buf, clientsName)
				local clients = vim.lsp.get_clients({ bufnr = buf })

				for _, client in pairs(clients) do
					for _, name in pairs(clientsName) do
						if client.name == name then
							return true
						end
					end
				end

				return false
			end

			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					sql = { "pg_format" },
					templ = { "templ" },
					c = { "clang-format" },
					go = { "goimports", "golines", "gofumpt" },
					python = { "black" },
					javascript = { "prettierd" },
					javascriptreact = { "prettierd" },
					typescript = { "deno_fmt", "prettierd" },
					typescriptreact = { "prettierd" },
					vue = { "prettierd" },
					astro = { "prettierd" },
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
				formatters = {
					deno_fmt = {
						condition = function(self, ctx)
							return enableIfClients(ctx.buf, { "denols" })
						end,
					},
					prettierd = {
						condition = function(self, ctx)
							return enableIfClients(ctx.buf, { "vtsls", "astro" })
						end,
					},
				},
			})

			vim.keymap.set("n", "<leader>cf", function()
				require("conform").format({ async = true, lsp_fallback = true })
			end, { desc = "LSP: " .. "[F]ormat buffer" })
		end,
	},
	{
		"linux-cultist/venv-selector.nvim",
		branch = "regexp",
		config = function()
			require("venv-selector").setup({})
			vim.keymap.set("n", "<leader>cv", "<cmd>:VenvSelect<CR>", { desc = "Seelct VirtualEnv" })
		end,
	},
}
