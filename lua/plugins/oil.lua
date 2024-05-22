return {
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        config = function()
            require("oil").setup({
                columns = { "icon" },
                keymaps = {
                    ["<C-h>"] = false,
                    ["<C-l>"] = false,
                    ["<C-p>"] = false,
                    ["<M-h>"] = "actions.select_split",
                    ["<C-r>"] = "actions.refresh",
                },
                view_options = {
                    show_hidden = true,
                },
                default_file_explorer = true,
                skip_confirm_for_simple_edits = true,
            })

            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
            vim.keymap.set("n", "<leader>fd", require("oil").toggle_float)
        end,
    },
}
