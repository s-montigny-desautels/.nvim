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
		return cwd
	end

	return table.concat(path, "")
end

M.is_in_git = function()
	local job = require("plenary.job")

	local cwd = vim.loop.cwd()

	local _, code = job:new({
		command = "git",
		args = {
			"rev-parse",
			"--is-inside-work-tree",
		},
		cwd = cwd,
	}):sync()

	return code == 0
end

function M.foldexpr()
	local buf = vim.api.nvim_get_current_buf()

	if vim.bo[buf].buftype ~= "" then
		return "0"
	end

	if vim.bo[buf].filetype == "" then
		return "0"
	end

	local ok = pcall(vim.treesitter.get_parser, buf)

	if ok then
		return vim.treesitter.foldexpr()
	end

	return "0"
end

return M
