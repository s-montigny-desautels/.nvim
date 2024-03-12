local stages = require("notify.stages").static("bottom_up")

return {
    {
        "folke/noice.nvim",
        enabled = false,
        opts = {
            cmdline = {
                view = "cmdline",
            },
            popupmenu = { backend = "cmp" },
            presets = {
                bottom_search = true,
                lsp_doc_border = true,
            },
            routes = {
                {
                    filter = {
                        event = "notify",
                        find = "No information available",
                    },
                    opts = { skip = true },
                },
                {
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "%d+L, %d+B" },
                            { find = "; after #%d+" },
                            { find = "; before #%d+" },
                            { find = "%d fewer lines" },
                            { find = "%d more lines" },
                        },
                    },
                    opts = { skip = true },
                },
            },
        },
    },
    {
        "rcarriga/nvim-notify",
        enabled = false,
        opts = {
            timeout = 2000,
            render = "compact",
            stages = vim.list_extend({
                function(state)
                    if #state.open_windows >= 3 then
                        return nil
                    end
                    return stages[1](state)
                end,
            }, vim.list_slice(stages, 2, #stages)),
            top_down = false,
        },
    },
}
