local function split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

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
				keymap = {
					preset = "default",
					cmdline = {
						preset = "super-tab",
					},
				},

				sources = {
					default = { "lsp", "path", "buffer" },

					providers = {
						lsp = {
							transform_items = function(ctx, items)
								if vim.bo.filetype == "vue" then
									for _, item in ipairs(items) do
										if
											item.textEdit
											and string.find(item.textEdit.newText, '.+="$1"')
											and not string.match(item.textEdit.newText, "^:")
										then
											item.textEdit.newText = split(item.textEdit.newText, "=")[1]
										end
									end
								end

								return items
							end,
						},
					},
				},

				completion = {
					trigger = {
						show_on_insert_on_trigger_character = false,
					},
					menu = {
						border = "rounded",
						draw = {
							treesitter = { "lsp" },
						},
					},
					documentation = {
						auto_show = true,
						auto_show_delay_ms = 200,
						window = {
							border = "rounded",
						},
					},
				},

				signature = {
					enabled = true,
					window = {
						border = "rounded",
					},
				},
			})
		end,
	},
}
