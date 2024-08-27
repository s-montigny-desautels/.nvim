local function setup_node()
	local dap = require("dap")

	local registry = require("mason-registry")

	if not dap.adapters["pwa-node"] then
		require("dap").adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "node",
				args = {
					registry.get_package("js-debug-adapter"):get_install_path() .. "/js-debug/src/dapDebugServer.js",
					"${port}",
				},
			},
		}
	end

	if not dap.adapters["node"] then
		dap.adapters["node"] = function(cb, config)
			if config.type == "node" then
				config.type = "pwa-node"
			end
			local nativeAdapter = dap.adapters["pwa-node"]
			if type(nativeAdapter) == "function" then
				nativeAdapter(cb, config)
			else
				cb(nativeAdapter)
			end
		end
	end

	local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

	for _, language in ipairs(js_filetypes) do
		if not dap.configurations[language] then
			dap.configurations[language] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
				},
			}
		end
	end
end

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"jay-babu/mason-nvim-dap.nvim",
			"leoluz/nvim-dap-go",
			"williamboman/mason.nvim",
		},
		config = function()
			require("nvim-dap-virtual-text").setup({})

			require("mason-nvim-dap").setup({
				automatic_installation = true,
				handlers = {},
				ensure_installed = { "delve", "js-debug-adapter" },
			})

			require("dap-go").setup()
			setup_node()

			local dap = require("dap")
			local dapui = require("dapui")

			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end

			local function map(key, fn, desc)
				vim.keymap.set("n", key, fn, { desc = desc })
			end


			require("which-key").add({
				{ "<leader>d", group = "[D]ebug" },
			})

			map("<leader>du", function()
				dapui.toggle({})
			end, "Dap UI")

			map("<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, "Breakpoint Condition")

			map("<leader>db", function()
				dap.toggle_breakpoint()
			end, "Toggle Breakpoint")

			map("<leader>dt", function()
				dap.terminate()
			end, "Terminate")

			map("<F5>", function()
				require("dap").continue()
			end, "Continue")

			map("<F10>", function()
				require("dap").step_over()
			end, "Step over")

			map("<F11>", function()
				require("dap").step_into()
			end, "Set into")

			map("<F12>", function()
				require("dap").step_out()
			end, "Step out")
		end,
	},
}
