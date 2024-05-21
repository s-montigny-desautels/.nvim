return {
    {
        "j-hui/fidget.nvim",
        opts = {},
    },
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            local util = require("lspconfig.util")
            local mason_registry = require("mason-registry")

            local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
                .. "/node_modules/@vue/language-server"

            local _opts = {
                servers = {
                    volar = {
                        root_dir = util.root_pattern(".git"),
                        init_options = {
                            vue = {
                                hybridMode = true,
                            },
                        },
                    },
                    tsserver = {
                        root_dir = util.root_pattern(".git"),
                        implicitProjectConfiguration = {
                            checkJs = true,
                        },
                        init_options = {
                            preferences = {
                                importModuleSpecifierPreference = "relative",
                                importModuleSpecifierEnding = "minimal",
                            },
                            plugins = {
                                {
                                    name = "@vue/typescript-plugin",
                                    location = vue_language_server_path,
                                    languages = { "vue" },
                                },
                            },
                        },
                        filetypes = {
                            "typescript",
                            "typescriptreact",
                            "javascript",
                            "javascriptreact",
                            "json",
                            "jsonc",
                            "vue",
                        },
                    },
                    pyright = {
                        settings = {
                            python = {
                                analysis = {
                                    reportUnusedImport = "none",
                                    reportUnusedClass = "none",
                                    reportUnusedFunction = "none",
                                    reportUnusedVariable = "none",
                                },
                            },
                        },
                    },
                },
                -- Custom setup for servers.
                -- Need to return true if the server is handled
                setup = {
                    ["*"] = function(server, serverOpts)
                        local neoconf = require("neoconf")
                        if neoconf.get(server .. ".disable") then
                            return true
                        end

                        local server_opts =
                            vim.tbl_deep_extend("force", serverOpts, neoconf.get(server .. ".settings") or {})
                        require("lspconfig")[server].setup(server_opts)

                        return true
                    end,
                },
            }

            opts = vim.tbl_deep_extend("force", opts, _opts)
            return opts
        end,
    },
    {
        "mfussenegger/nvim-lint",
        optional = true,
        opts = {
            linters_by_ft = {
                terraform = {},
                tf = {},
            },
        },
    },
    {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
            local cmp = require("cmp")

            opts.experimental.ghost_text = false

            opts.mapping["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select })
            opts.mapping["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select })

            opts.mapping["<CR>"] = nil
            opts.mapping["<S-CR>"] = nil
            opts.mapping["<C-CR>"] = nil

            return opts
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        keys = {
            { "<tab>", mode = { "s", "i" }, false },
        },
    },
    {
        "mfussenegger/nvim-dap",
        keys = {
            {
                "<F5>",
                function()
                    require("dap").continue()
                end,
                { desc = "Continue" },
            },

            {

                "<F10>",
                function()
                    require("dap").step_over()
                end,
                { desc = "Step over" },
            },

            {
                "<F11>",
                function()
                    require("dap").step_into()
                end,

                { desc = "Set into" },
            },

            {
                "<F12>",
                function()
                    require("dap").step_out()
                end,
                { desc = "Step out" },
            },
        },
    },
}
