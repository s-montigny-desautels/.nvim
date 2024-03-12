return {
    "folke/zen-mode.nvim",
    opts = {
        window = {
            backdrop = 0.5,
            height = 1,
            width = 160,
        },
    },
    keys = {
        {
            "<leader>z",
            function()
                require("zen-mode").toggle()
            end,
            desc = "",
        },
    },
}
