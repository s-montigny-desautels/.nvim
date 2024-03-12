return {
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        keys = {
            {
                "<leader>fd",
                function()
                    require("oil").open_float(nil)
                end,
            },
        },
        config = function()
            require("oil").setup({
                default_file_explorer = true,
                skip_confirm_for_simple_edits = true,
                view_options = {
                    show_hidden = true,
                },
            })
        end,
    },
}
