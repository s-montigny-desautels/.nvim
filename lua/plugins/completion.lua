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
		"saghen/blink.cmp",
		lazy = false,
		enabled = true,
		version = "1.5.1",
		config = function()
			---@diagnostic disable missing-fields
			require("blink-cmp").setup({
				keymap = {
					preset = "default",
				},

				sources = {
					default = { "lazydev", "lsp", "path", "buffer" },

					providers = {
						lazydev = {
							name = "LazyDev",
							module = "lazydev.integrations.blink",
							-- make lazydev completions top priority (see `:h blink.cmp`)
							score_offset = 100,
						},
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

				fuzzy = { implementation = "lua" },

				completion = {
					keyword = { range = "full" },
					accept = { auto_brackets = { enabled = false } },
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
					trigger = {
						enabled = false,
					},
					window = {
						border = "rounded",
					},
				},
			})
		end,
	},
}
