local Util = require("lazyvim.util")

return {
    {
        "nvim-telescope/telescope.nvim",
        lazy = false,
        dependencies = {
            {
                "nvim-telescope/telescope-file-browser.nvim",
                lazy = false,
                config = function()
                    Util.on_load("telescope.nvim", function()
                        require("telescope").load_extension("file_browser")
                    end)
                end,
            },
            {
                "debugloop/telescope-undo.nvim",
                lazy = false,
                config = function()
                    Util.on_load("telescope.nvim", function()
                        require("telescope").load_extension("undo")
                    end)
                end,
            },
        },
        keys = {
            {
                "<leader>su",
                function()
                    require("telescope").extensions.undo.undo({
                        initial_mode = "normal",
                    })
                end,
                desc = "search undo history",
            },
            {
                "<leader>ff",
                Util.telescope("find_files", {
                    hidden = true,
                    no_ignore = true,
                    file_ignore_patterns = { "node_module", ".git" },
                }),
                desc = "Find files (root dir, no ignore)",
            },
            -- {
            --     "<leader>fd",
            --     function()
            --         local telescope = require("telescope")
            --         local function telescope_buffer_dir()
            --             return vim.fn.expand("%:p:h")
            --         end
            --
            --         telescope.extensions.file_browser.file_browser({
            --             path = "%:p:h",
            --             cwd = telescope_buffer_dir(),
            --             respect_gitignore = false,
            --             hidden = true,
            --             grouped = true,
            --             previewer = false,
            --             initial_mode = "normal",
            --             layout_config = { height = 40 },
            --             select_buffer = true,
            --         })
            --     end,
            --     desc = "File browser (current file dir)",
            -- },
        },
        opts = {
            defaults = {
                wrap_result = true,
                layout_strategy = "horizontal",
                layout_config = { prompt_position = "top" },
                sorting_strategy = "ascending",
            },
            pickers = {
                diagnostics = {
                    theme = "ivy",
                    initial_mode = "normal",
                },
            },
            extensions = {
                file_browser = {
                    theme = "dropdown",
                },
            },
        },
    },
}
