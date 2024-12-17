return {
	{
		"hrsh7th/nvim-cmp",
		lazy = false,
		enabled = false,
		priority = 100,
		dependencies = {
			"onsails/lspkind.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
		},
		config = function()
			require("lspkind").init({})

			local cmp = require("cmp")

			vim.opt.completeopt = { "menu", "menuone", "noselect" }
			vim.opt.pumblend = 10
			vim.opt.pumheight = 10

			cmp.setup({
				sources = {
					{ name = "nvim_lsp" },
					{ name = "path" },
					{ name = "buffer" },
				},
				mapping = {
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-y>"] = cmp.mapping(
						cmp.mapping.confirm({
							behavior = cmp.ConfirmBehavior.Insert,
							select = true,
						}),
						{ "i", "c" }
					),
					["<C-Space>"] = cmp.mapping.complete({}),
				},
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
			})

			cmp.setup.filetype({ "sql" }, {
				sources = {
					{ name = "vim-dadbod-completion" },
					{ name = "buffer" },
				},
			})
		end,
	},
	{
		"saghen/blink.cmp",
		lazy = false,
		version = "v0.*",
		config = function()
			---@diagnostic disable missing-fields
			require("blink-cmp").setup({
				keymap = { preset = "default" },

				appearance = {
				},

				sources = {
					default = { "lsp", "path", "buffer" },
				},

				completion = {
					trigger = {
						show_on_insert_on_trigger_character = false,

					},
					menu = {
						border = "rounded",
						draw = {
							columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
						},
					},
				},
			})
		end,
	},
}
