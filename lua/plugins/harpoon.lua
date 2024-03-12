return {
    "ThePrimeagen/harpoon",
    enabled = true,
    lazy=false,
    branch = "harpoon2",
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup({
            menu = {
                width = vim.api.nvim_win_get_width(0) - 4,
            },
        })

        harpoon:extend({
            UI_CREATE = function(cx)
                vim.keymap.set("n", "<esc>", "", { buffer = cx.bufnr })
            end,
        })
    end,
    keys = {
        {
            "<leader>H",
            function()
                require("harpoon"):list():append()
            end,
            desc = "Harpoon file",
        },
        {
            "<leader>h",
            function()
                local harpoon = require("harpoon")
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end,
            desc = "Harpoon quick menu",
        },
        {
            "<leader>1",
            function()
                require("harpoon"):list():select(1)
            end,
            desc = "Harpoon to file 1",
        },
        {
            "<leader>2",
            function()
                require("harpoon"):list():select(2)
            end,
            desc = "Harpoon to file 2",
        },
        {
            "<leader>3",
            function()
                require("harpoon"):list():select(3)
            end,
            desc = "Harpoon to file 3",
        },
        {
            "<leader>4",
            function()
                require("harpoon"):list():select(4)
            end,
            desc = "Harpoon to file 4",
        },
        {
            "<leader>5",
            function()
                require("harpoon"):list():select(5)
            end,
            desc = "Harpoon to file 5",
        },
    },
}
