return {
    { "echasnovski/mini.pairs", enabled = false },
    { "rafamadriz/friendly-snippets", enabled = false },
    { "nvim-treesitter/nvim-treesitter-context", enabled = false },
    { "folke/flash.nvim", enabled = false },
    { "lukas-reineke/headlines.nvim", enabled = false },
    {
        "catppuccin",
        opts = {
            transparent_background = true,
            highlight_overrides = {
                all = function(colors)
                    return {
						-- https://github.com/catppuccin/nvim/issues/699
						-- The default color is bad for my color blindness
                        ["@keyword.operator"] = { fg = colors.mauve },
                    }
                end,
            },
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                icons_enabled = false,
                theme = "auto",
                component_separators = "|",
                section_separators = "",
            },
        },
    },
    {
        "folke/which-key.nvim",
        opts = {
            triggers = { "<leader>", "g" },
        },
    },
    {
        "nvimdev/dashboard-nvim",
        event = "VimEnter",
        opts = function(_, opts)
            local logo = [[
██████╗ ██╗ ██████╗      ██████╗██╗  ██╗ ██████╗ ██╗    ██╗███╗   ██╗
██╔══██╗██║██╔════╝     ██╔════╝██║  ██║██╔═══██╗██║    ██║████╗  ██║
██████╔╝██║██║  ███╗    ██║     ███████║██║   ██║██║ █╗ ██║██╔██╗ ██║
██╔══██╗██║██║   ██║    ██║     ██╔══██║██║   ██║██║███╗██║██║╚██╗██║
██████╔╝██║╚██████╔╝    ╚██████╗██║  ██║╚██████╔╝╚███╔███╔╝██║ ╚████║
╚═════╝ ╚═╝ ╚═════╝      ╚═════╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═══╝
                                                                     
            ]]

            logo = string.rep("\n", 8) .. logo:gsub("\t+", "") .. "\n\n"
            opts.config.header = vim.split(logo, "\n")
        end,
    },
}
