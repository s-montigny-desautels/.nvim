-- Disabled default dark theme
vim.cmd("highlight Normal guibg=NONE guifg=NONE ctermbg=NONE ctermfg=NONE")

require("vim._core.ui2").enable({ msg = { target = "cmd" } })

require("config")
