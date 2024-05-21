return {
    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            table.insert(opts.ensure_installed, "prettierd")
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        optional = true,
        opts = function(_, opts)
            local nls = require("null-ls")
            opts.sources = opts.sources or {}
            table.insert(opts.sources, nls.builtins.formatting.prettierd)
        end,
    },
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = {
            formatters_by_ft = {
                ["sql"] = { "sql_formatter" },
                ["templ"] = { "templ" },
                ["c"] = { "clang-format" },
                ["javascript"] = { "prettierd" },
                ["javascriptreact"] = { "prettierd" },
                ["typescript"] = { "prettierd" },
                ["typescriptreact"] = { "prettierd" },
                ["vue"] = { "prettierd" },
                ["css"] = { "prettierd" },
                ["scss"] = { "prettierd" },
                ["less"] = { "prettierd" },
                ["html"] = { "prettierd" },
                ["json"] = { "prettierd" },
                ["jsonc"] = { "prettierd" },
                ["yaml"] = { "prettierd" },
                ["markdown"] = { "prettierd" },
                ["markdown.mdx"] = { "prettierd" },
                ["graphql"] = { "prettierd" },
                ["handlebars"] = { "prettierd" },
            },
            formatters = {
                sql_formatter = {
                    prepend_args = { "-c", '{"keywordCase": "upper", "dataTypeCase": "upper"}' },
                },
            },
        },
    },
}
