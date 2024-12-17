local M = {}

local terminals = {}

M.open = function(cmd, opts)
	local key = cmd or "shell"

	opts = vim.tbl_deep_extend("force", {
		ft = "floating_term",
		size = { width = 0.9, height = 0.9 },
		border = "rounded",
		backdrop = 100,
	}, opts or {}, { persistent = true })

	if terminals[key] and terminals[key]:buf_valid() then
		terminals[key]:toggle()
	else
		local terminal = require("lazy.util").float_term(cmd, opts)
		terminals[key] = terminal

		local buf = terminal.buf

		if opts.esc_esc == false then
			vim.keymap.set("t", "<esc>", "<esc>", { buffer = buf, nowait = true })
		end
		if opts.ctrl_hjkl == false then
			vim.keymap.set("t", "<c-h>", "<c-h>", { buffer = buf, nowait = true })
			vim.keymap.set("t", "<c-j>", "<c-j>", { buffer = buf, nowait = true })
			vim.keymap.set("t", "<c-k>", "<c-k>", { buffer = buf, nowait = true })
			vim.keymap.set("t", "<c-l>", "<c-l>", { buffer = buf, nowait = true })
		end

		vim.api.nvim_create_autocmd("BufEnter", {
			buffer = buf,
			callback = function()
				vim.cmd.startinsert()
			end,
		})

		vim.cmd("noh")
	end

	return terminals[key]
end

return M
