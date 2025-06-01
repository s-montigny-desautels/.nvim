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
	if vim.b[buf].ts_folds == nil then
		-- as long as we don't have a filetype, don't bother
		-- checking if treesitter is available (it won't)
		if vim.bo[buf].filetype == "" then
			return "0"
		end

		vim.b[buf].ts_folds = pcall(vim.treesitter.get_parser, buf)
	end

	return vim.b[buf].ts_folds and vim.treesitter.foldexpr() or "0"
end

function M.get_pkg_path(pkg, path)
	pcall(require, "mason")
	local root = vim.env.MASON

	path = path or ""

	return root .. "/packages/" .. pkg .. "/" .. path
end

return M
