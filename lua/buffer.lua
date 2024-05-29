local util = require("util")

local M = {}

M.list = function(opts)
	opts = opts or {}

	local bufnrs = vim.tbl_filter(function(bufnr)
		if 1 ~= vim.fn.buflisted(bufnr) then
			return false
		end

		-- only hide unloaded buffers if opts.show_all_buffers is false, keep them listed if true or nil
		if not vim.api.nvim_buf_is_loaded(bufnr) then
			return false
		end
		if opts.ignore_current_buffer and bufnr == vim.api.nvim_get_current_buf() then
			return false
		end

		return true
	end, vim.api.nvim_list_bufs())

	return bufnrs
end

M.close_others = function()
	local buffers = M.list({ ignore_current_buffer = true })

	for _, buf in pairs(buffers) do
		vim.api.nvim_buf_delete(buf, { force = false })
	end
end

return M
