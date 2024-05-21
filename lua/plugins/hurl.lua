return {
    "jellydn/hurl.nvim",
    ft = "hurl",
    opts = {
        -- Show debugging info
        debug = false,
        -- Show notification on run
        show_notification = false,
        -- Show response in popup or split
        mode = "popup",
        -- Default formatter
        formatters = {
            json = { "jq" }, -- Make sure you have install jq in your system, e.g: brew install jq
            html = {
                "prettier", -- Make sure you have install prettier in your system, e.g: npm install -g prettier
                "--parser",
                "html",
            },
        },
    },
    keys = {
        -- Run API request
        { "<leader>rR", "<cmd>HurlRunner<CR>", desc = "Run All requests" },
        { "<leader>rr", "<cmd>HurlRunnerAt<CR>", desc = "Run Api request" },
        { "<leader>rT", "<cmd>HurlToggleMode<CR>", desc = "Hurl Toggle Mode" },
        { "<leader>rv", "<cmd>HurlVerbose<CR>", desc = "Run Api in verbose mode" },
    },
}
