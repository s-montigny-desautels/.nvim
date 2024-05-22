local M = {}

M.dump = function(o)
	if type(o) == "table" then
		local s = "{ "
		for k, v in pairs(o) do
			if type(k) ~= "number" then
				k = '"' .. k .. '"'
			end
			s = s .. "[" .. k .. "] = " .. M.dump(v) .. ","
		end
		return s .. "} "
	else
		return tostring(o)
	end
end

M.root_dir = function()
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

return M
