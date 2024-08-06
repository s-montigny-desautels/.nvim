return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		build = ":TSUpdate",
		lazy = false,
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
			},
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				modules = {},
				ignore_install = {},
				ensure_installed = {
					"c",
					"bash",
					"lua",
					"vim",
					"vimdoc",
					"markdown",
					"query",
					"go",
					"gomod",
					"gowork",
					"gosum",
				},
				auto_install = true,
				sync_install = false,
				highlight = { enable = true },
				additional_vim_regex_highlighting = false,
				indent = { enabled = true },
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
						goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
						goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
						goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
					},
				},
			})

			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			parser_config.bruno = {
				install_info = {
					url = "~/oss/tree-sitter-bruno",
					files = { "src/parser.c", "src/scanner.c" },
					branch = "main",
					generate_requires_npm = true,
					requires_generate_from_grammar = false,
				},
				filetype = "bru",
			}
		end,
	},
}
