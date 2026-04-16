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
			settings = {
				vue = {
					suggest = {
						propNameCasing = "alwaysCamelCase",
						componentNameCasing = "alwaysPascalCase",
					},
				},
			},
			on_attach = function(client)
				client.server_capabilities.semanticTokensProvider.full = true
			end,
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
					-- tsserver = {
					-- 	log = "verbose",
					-- },
				},
			},
			on_attach = function(client)
				if vim.bo.filetype == "vue" then
					client.server_capabilities.semanticTokensProvider.full = false
				else
					client.server_capabilities.semanticTokensProvider.full = true
				end
			end,
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

	-- LSP setup
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"b0o/SchemaStore.nvim",
		},
		config = function()
			-- require("which-key").add({
			-- 	{ "<leader>c", group = "[C]ode" },
			-- 	{ "<leader>cl", group = "[C]ode [L]sp" },
			-- })

			local servers = server_settings()

			for name, config in pairs(servers) do
				vim.lsp.config(name, config)
			end

			local registry = require("mason-registry")

			local function enable(name)
				local package_mapping = {}
				for _, spec in ipairs(registry.get_all_package_specs()) do
					local lspconfig = vim.tbl_get(spec, "neovim", "lspconfig")
					if lspconfig then
						package_mapping[spec.name] = lspconfig
					end
				end

				local lspconfig_name = package_mapping[name]
				if not lspconfig_name then
					lspconfig_name = name
				end

				vim.lsp.enable(lspconfig_name)
			end

			for _, name in pairs(registry.get_installed_package_names()) do
				enable(name)
			end

			registry:on("package:install:success", function(pkg)
				vim.schedule(function()
					enable(pkg.name)
				end)
			end)

			-- I hate this.
			vim.lsp.inlay_hint.enable(false)

			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				callback = function()
					vim.lsp.buf.document_highlight()
				end,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved" }, {
				callback = function()
					vim.lsp.buf.clear_references()
				end,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local buf = args.buf ---@type number

					local function map(keys, func, desc, mode)
						if mode == nil then
							mode = "n"
						end
						vim.keymap.set(mode, keys, func, { buffer = buf, desc = "LSP: " .. desc })
					end

					map("K", function()
						vim.lsp.buf.hover({ silent = true })
					end, "Hover Documentation")

					map("<leader>cr", function()
						vim.lsp.buf.rename()
					end, "[C]ode [R]ename")

					map("<leader>cA", function()
						vim.lsp.buf.code_action()
					end, "[C]ode [A]ction line or selection", { "n", "x" })

					map("<leader>ca", function()
						vim.lsp.buf.code_action({
							context = {
								only = { "source" },
								diagnostics = {},
							},
						})
					end, "[C]ode [A]ction file", { "n", "x" })

					map("<leader>clr", function()
						vim.cmd("lsp restart")
					end, "[L]sp [R]estart")

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
				end,
			})
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
					go = { "goimports", "gofumpt" },
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
					pg_format = {
						append_args = function(self, ctx)
							return { "-t", "--no-space-function", "--keep-newline", "--comma-break", "--comma-start" }
						end,
					},
					prettierd = {
						condition = function(self, ctx)
							return enableIfClients(ctx.buf, { "vtsls", "astro", "jsonls", "marksman" })
						end,
					},
				},
			})

			vim.keymap.set("n", "<leader>cf", function()
				require("conform").format({ async = true, lsp_fallback = true })
			end, { desc = "LSP: " .. "[F]ormat buffer" })
		end,
	},
}
