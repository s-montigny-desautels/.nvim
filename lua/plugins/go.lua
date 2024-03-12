return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                gopls = {
                    settings = {
                        gopls = {
                            usePlaceholders = false,
                            analyses = {
                                fieldalignment = false,
                            },
                        },
                    },
                },
            },
        },
    },
    {
        "nvim-neotest/neotest",
        optional = true,
        dependencies = {
            "nvim-neotest/neotest-go",
        },
        opts = {
            adapters = {
                ["neotest-go"] = {
                    recursive_run = true,
                },
            },
        },
    },
}
