return {
	{
		"nvim-mini/mini.ai",
		version = false,
		config = function()
			require("mini.ai").setup()
		end,
	},
	{
		"nvim-mini/mini.surround",
		version = false,
		config = function()
			require("mini.surround").setup()
		end,
	},
	{
		"nvim-mini/mini.pick",
		version = false,
		config = function()
			require("mini.pick").setup()
		end,
	},
	{
		"nvim-mini/mini.extra",
		version = false,
		config = function()
			require("mini.extra").setup()
		end,
	},
}
