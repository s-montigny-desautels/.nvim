local job = require("plenary.job")

local setTheme = function(val)
	vim.schedule(function()
		if val == "1" then
			vim.cmd("colorscheme kanagawa-wave")
		else
			vim.cmd("colorscheme catppuccin-latte")
		end
	end)
end

job:new({
	command = "gnome-theme-watcher",
	on_stdout = function(_, val)
		if val == nil then
			return
		end
		setTheme(val)
	end,
}):start()

job:new({
	command = "gnome-theme-watcher",
	args = { "--watch" },
	on_stdout = function(_, val)
		setTheme(val)
	end,
}):start()
