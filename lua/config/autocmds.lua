-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--

-- local Util = require("lazyvim.util")
--
--

local function dump(o)
    if type(o) == "table" then
        local s = "{ "
        for k, v in pairs(o) do
            if type(k) ~= "number" then
                k = '"' .. k .. '"'
            end
            s = s .. "[" .. k .. "] = " .. dump(v) .. ","
        end
        return s .. "} "
    else
        return tostring(o)
    end
end

-- Save on buffer exit
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
    callback = function(args)
        if args.file == nil or args.file == "" then
            return
        end

        if string.find(args.file, "^oil") then
            return
        end

        if string.find(args.file, "__harpoon") then
            return
        end

        -- local buf = args.buf

        -- local found = false
        -- for _, formatter in ipairs(Util.format.resolve(buf) or {}) do
        --     if formatter.active then
        --         found = true
        --     end
        -- end
        -- --
        -- if not found then
        --     return
        -- end
        --
        -- Util.format.format({ force = true, buf = args.buf })
        vim.cmd("wa")
    end,
})

-- show cursor line only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
    callback = function()
        local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
        if ok and cl then
            vim.wo.cursorline = true
            vim.api.nvim_win_del_var(0, "auto-cursorline")
        end
    end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
    callback = function()
        local cl = vim.wo.cursorline
        if cl then
            vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
            vim.wo.cursorline = false
        end
    end,
})

-- gopls cgo generate

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local buf = ev.buf

        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client.supports_method("textDocument/codeLens", { bufnr = buf }) then
            return
        end

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
    end,
})
