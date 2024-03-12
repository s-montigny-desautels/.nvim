local Job = require("plenary.job")

local setTheme = function(val)
    vim.schedule(function()
        if val == "1" then
            vim.cmd("colorscheme catppuccin-mocha")
        else
            vim.cmd("colorscheme catppuccin-latte")
        end
    end)
end

Job:new({
    command = "gnome-theme-watcher",
    args = { "--watch" },
    on_stdout = function(_, val)
        setTheme(val)
    end,
}):start()
