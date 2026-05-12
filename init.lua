-- Disabled default dark theme
vim.cmd("highlight Normal guibg=NONE guifg=NONE ctermbg=NONE ctermfg=NONE")

_G.Config = {}

--- Create a github url
Config.gh = function(x) return "https://github.com/" .. x end

Config.add = function(spec) vim.pack.add(spec, { confirm = false }) end

Config.add({ Config.gh("nvim-mini/mini.nvim") })

local misc = require("mini.misc")

-- Utilies to lazy load some package
Config.now = function(f) misc.safely("now", f) end
Config.later = function(f) misc.safely("later", f) end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
Config.on_event = function(ev, f) misc.safely("event:" .. ev, f) end
Config.on_filetype = function(ft, f) misc.safely("filetype:" .. ft, f) end

local gr = vim.api.nvim_create_augroup("custom-config", {})
Config.new_autocmd = function(event, pattern, callback, desc)
	local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
	vim.api.nvim_create_autocmd(event, opts)
end

Config.on_packchanged = function(plugin_name, kinds, callback, desc)
	Config.new_autocmd("PackChanged", "*", function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then
			return
		end
		if not ev.data.active then vim.cmd.packadd(plugin_name) end

		callback(ev.data)
	end, desc)
end

-- Keymap utilities
local K = {}

K.map = function(mode, lhs, rhs, desc, opts)
	vim.keymap.set(
		mode,
		lhs,
		rhs,
		vim.tbl_extend("force", opts or {}, { desc = desc })
	)
end

K.nmap = function(lhs, rhs, desc, opts) K.map("n", lhs, rhs, desc, opts) end
K.vmap = function(lhs, rhs, desc, opts) K.map("v", lhs, rhs, desc, opts) end
K.xmap = function(lhs, rhs, desc, opts) K.map("x", lhs, rhs, desc, opts) end
K.nmap_leader = function(suffix, rhs, desc, opts)
	K.nmap("<Leader>" .. suffix, rhs, desc, opts)
end
K.xmap_leader = function(suffix, rhs, desc, opts)
	K.xmap("<Leader>" .. suffix, rhs, desc, opts)
end

Config.keymap = K

-- Buffers utils
local B = {}

B.list = function(opts)
	opts = opts or {}

	local bufnrs = vim.tbl_filter(function(bufnr)
		if 1 ~= vim.fn.buflisted(bufnr) then return false end

		-- only hide unloaded buffers if opts.show_all_buffers is false, keep them listed if true or nil
		if not vim.api.nvim_buf_is_loaded(bufnr) then return false end
		if
			opts.ignore_current_buffer
			and bufnr == vim.api.nvim_get_current_buf()
		then
			return false
		end

		return true
	end, vim.api.nvim_list_bufs())

	return bufnrs
end

B.close_unamed = function()
	local buffers = B.list()
	for _, buf in pairs(buffers) do
		local name = vim.api.nvim_buf_get_name(buf)
		if name == "" then vim.api.nvim_buf_delete(buf, { force = true }) end
	end
end

Config.buffer = B

-- Utilies
local U = {}

--- Return a string representing the given table.
U.dump = function(o)
	if type(o) == "table" then
		local s = "{ "
		for k, v in pairs(o) do
			if type(k) ~= "number" then k = '"' .. k .. '"' end
			s = s .. "[" .. k .. "] = " .. M.dump(v) .. ","
		end
		return s .. "} "
	else
		return tostring(o)
	end
end

U.root_dir = function()
	local cwd = vim.loop.cwd()

	local obj = vim.system(
		{ "git", "rev-parse", "--show-toplevel" },
		{ text = true, cwd = cwd }
	):wait()
	if obj.code ~= 0 then return nil end

	return obj.stdout
end

U.is_in_git = function()
	local cwd = vim.loop.cwd()

	local obj = vim.system(
		{ "git", "rev-parse", "--is-inside-work-tree" },
		{ cwd = cwd }
	)
		:wait()
	return obj.code == 0
end

U.get_pkg_path = function(pkg, path)
	pcall(require, "mason")
	local root = vim.env.MASON

	path = path or ""

	return root .. "/packages/" .. pkg .. "/" .. path
end

Config.util = U
