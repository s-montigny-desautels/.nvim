local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
    spec = {
        {
            "LazyVim/LazyVim",
            import = "lazyvim.plugins",
            opts = {
                colorscheme = function()
                    local job = require("plenary.job")
                    job:new({
                        command = "gnome-theme-watcher",
                        on_stdout = function(_, val)
                            vim.schedule(function()
                                if val == "1" then
                                    vim.cmd("colorscheme catppuccin-mocha")
                                else
                                    vim.cmd("colorscheme catppuccin-latte")
                                end
                            end)
                        end,
                    }):start()
                end,
            },
        },

        -- Lang
        { import = "lazyvim.plugins.extras.lang.typescript" },
        { import = "lazyvim.plugins.extras.lang.json" },
        { import = "lazyvim.plugins.extras.lang.docker" },
        { import = "lazyvim.plugins.extras.lang.go" },
        { import = "lazyvim.plugins.extras.lang.markdown" },
        { import = "lazyvim.plugins.extras.lang.python" },
        { import = "lazyvim.plugins.extras.lang.tailwind" },
        { import = "lazyvim.plugins.extras.lang.terraform" },

        -- Debugging
        { import = "lazyvim.plugins.extras.dap.core" },
        --Formatting
        { import = "lazyvim.plugins.extras.formatting.black" },

        -- Test
        { import = "lazyvim.plugins.extras.test.core" },

        -- My plugins
        { import = "plugins" },
    },
    defaults = {
        lazy = false,
        version = false, -- always use the latest git commit
    },
    install = { colorscheme = { "catppuccin" } },
    checker = { enabled = false }, -- automatically check for plugin updates
    change_detection = { notify = false },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
