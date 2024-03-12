return {
    "nvim-neo-tree/neo-tree.nvim",
    init = nil,
    opts = {
        filesystem = {
            bind_to_cwd = true,
            follow_current_file = { enabled = false },
            hijack_netrw_behavior = "disabled",
            filtered_items = {
                visible = true, -- when true, they will just be displayed differently than normal items
                hide_dotfiles = true,
                hide_gitignored = true,
                hide_by_pattern = { -- uses glob style patterns
                    --"*.meta",
                    --"*/src/*/tsconfig.json",
                },
                always_show = { -- remains visible even if other settings would normally hide it
                    --".gitignored",
                },
                never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                    ".git",
                },
                never_show_by_pattern = { -- uses glob style patterns
                    --".null-ls_*",
                },
            },
        },
    },
}
