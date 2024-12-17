local M = {}

M._supports_method = {}

function M.setup()
	local register_capability = vim.lsp.handlers["client/registerCapability"]
	vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
		local ret = register_capability(err, res, ctx)
		local client = vim.lsp.get_client_by_id(ctx.client_id)

		if client then
			for buffer in pairs(client.attached_buffers) do
				vim.api.nvim_exec_autocmds("User", {
					pattern = "LspDynamicCapability",
					data = { client_id = client.id, buffer = buffer },
				})
			end
		end

		return ret
	end

	M.setup_codelens()

	M.on_attach(function(client, buffer)
		M._check_methods(client, buffer)
		M._set_keymap(buffer)
	end)

	M.on_dynamic_capability(M._check_methods)
end

function M.on_attach(on_attach)
	return vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local buffer = args.buf ---@type number
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if client then
				return on_attach(client, buffer)
			end
		end,
	})
end

function M.on_dynamic_capability(fn)
	return vim.api.nvim_create_autocmd("User", {
		pattern = "LspDynamicCapability",
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			local buffer = args.data.buffer
			if client then
				return fn(client, buffer)
			end
		end,
	})
end

function M.on_support_method(method, fn)
	-- Set to empty table for the methods. Will be populated on _check_methods
	M._supports_method[method] = M._supports_method[method] or setmetatable({}, { __mode = "k" })

	return vim.api.nvim_create_autocmd("User", {
		pattern = "LspSupportsMethod",
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			local buffer = args.data.buffer ---@type number
			if client and method == args.data.method then
				return fn(client, buffer)
			end
		end,
	})
end

function M._check_methods(client, buffer)
	if not vim.api.nvim_buf_is_valid(buffer) then
		return
	end

	if not vim.bo[buffer].buflisted then
		return
	end

	if vim.bo[buffer].buftype == "nofile" then
		return
	end

	for method, clients in pairs(M._supports_method) do
		clients[client] = clients[client] or {}
		if not clients[client][buffer] then
			if client.supports_method and client.supports_method(method, { bufnr = buffer }) then
				clients[client][buffer] = true
				vim.api.nvim_exec_autocmds("User", {
					pattern = "LspSupportsMethod",
					data = { client_id = client.id, buffer = buffer, method = method },
				})
			end
		end
	end
end

function M._set_keymap(buf)
	local function map(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = buf, desc = "LSP: " .. desc })
	end

	local fzf = require("fzf-lua")

	map("gd", function()
		fzf.lsp_definitions({ jump_to_single_result = true })
	end, "[G]oto [D]efinition")

	map("gr", fzf.lsp_references, "[G]oto [R]eferences")
	map("gI", fzf.lsp_implementations, "[G]oto [I]mplementation")

	map("K", vim.lsp.buf.hover, "Hover Documentation")

	map("<leader>cr", vim.lsp.buf.rename, "[C]ode [R]ename")

	map("<leader>ca", function()
		vim.lsp.buf.code_action({
			context = {
				only = {
					"source",
				},
				diagnostics = {},
			},
		})
	end, "[C]ode [A]ction")
end

function M.setup_codelens()
	M.on_support_method("textDocument/codeLens", function(_, buf)
		vim.keymap.set("n", "<leader>cc", function()
			local params = {
				textDocument = vim.lsp.util.make_text_document_params(buf),
			}
			local result = vim.lsp.buf_request_sync(buf, "textDocument/codeLens", params, 3000)

			local codeLens = {}

			for _, res in pairs(result or {}) do
				for _, r in pairs(res.result or {}) do
					table.insert(codeLens, r)
				end
			end

			vim.ui.select(codeLens, {
				prompt = "Select code lens",
				format_item = function(item)
					return item.command.title .. " (line " .. item.range.start.line .. ")"
				end,
			}, function(selected)
				if not selected then
					return
				end
				vim.lsp.buf_request_sync(buf, "workspace/executeCommand", selected.command, 3000)
			end)
		end, {
			desc = "Code Lens",
			buffer = buf,
		})
	end)
end

return M
