return {
    "nvim-neotest/neotest",
    dependencies = {
        "marilari88/neotest-vitest",
    },
    opts = {
        adapters = {
            ["neotest-vitest"] = {},
        },
    },
    keys = {
        {
            "<leader>tt",
            function()
                vim.cmd("wa")
                require("neotest").run.run(vim.fn.expand("%"))
            end,
            desc = "Run File",
        },
        {
            "<leader>tT",
            function()
                vim.cmd("wa")
                require("neotest").run.run(vim.loop.cwd())
            end,
            desc = "Run All Test Files",
        },
        {
            "<leader>tr",
            function()
                vim.cmd("wa")
                require("neotest").run.run()
            end,
            desc = "Run Nearest",
        },
    },
}
