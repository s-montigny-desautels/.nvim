local terminal = require("config.terminal")

local function root_dir()
	local job = require("plenary.job")

	local cwd = vim.loop.cwd()

	local path, code = job:new({
		command = "git",
		args = {
			"rev-parse",
			"--show-toplevel",
		},
		cwd = cwd,
	}):sync()

	if code ~= 0 then
		return nil
	end

	return table.concat(path, "")
end

local M = {}

M.open = function()
	local root = root_dir()

	terminal.open("lazygit", { cwd = root, esc_esc = false, ctrl_hjkl = false })
end

return M
