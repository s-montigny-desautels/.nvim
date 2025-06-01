local opt = vim.opt

vim.g.root_spec = { { ".git", "lua" }, "cwd" }

opt.clipboard = "unnamedplus"
opt.confirm = true

opt.number = true
opt.relativenumber = true

opt.showmode = false

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = false
opt.smartindent = true

opt.wrap = false
opt.linebreak = true

opt.swapfile = false
opt.backup = false
opt.undofile = true

opt.ignorecase = true
opt.smartcase = true

opt.updatetime = 250
opt.timeoutlen = 300
opt.conceallevel = 2

opt.splitright = true
opt.splitbelow = true

opt.hlsearch = false
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

opt.inccommand = "split"
opt.termguicolors = true

opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

opt.cursorline = true

opt.scrolloff = 8
opt.signcolumn = "yes"

opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

vim.g.autoformat = false

opt.shortmess:append({ W = true, c = true, C = true })

opt.smoothscroll = true
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.require'util'.foldexpr()"
opt.foldtext = ""
opt.foldlevel = 99

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = "rounded"
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

vim.filetype.add({
	extension = {
		templ = "templ",
		bru = "bruno",
	},
})
