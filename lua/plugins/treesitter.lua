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
				ensure_installed = { "c", "bash", "lua", "vim", "vimdoc", "markdown", "query" },
				auto_install = true,
				sync_install = false,
				highlight = { enable = true },
				additional_vim_regex_highlighting = false,
				indent = { enabled = true },
				textobjects = {
					move = {
						enable = true,
						goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
						goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
						goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
						goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
					},
				},
			})
		end,
	},
}
