local terminal = require("config.terminal")
local util = require("util")

local M = {}

M.open = function()
	local root = util.root_dir()

	terminal.open("lazygit", { cwd = root, esc_esc = false, ctrl_hjkl = false })
end

return M
