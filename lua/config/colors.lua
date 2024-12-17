local job = require("plenary.job")

local setTheme = function(val)
	vim.schedule(function()
		if val == "1" then
			vim.cmd("colorscheme catppuccin-mocha")
		else
			vim.cmd("colorscheme catppuccin-latte")
		end
	end)
end

job:new({
	command = "gnome-theme-watcher",
	on_stdout = function(_, val)
		setTheme(val)

		-- Set theme two time, zen-mode don't color the backdrop correctly for some reason otherwise...
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
