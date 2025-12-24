--- vim.g ---

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.have_nerd_font = true

vim.g.snacks_animate = false

--- vim.opt ---

vim.opt.title = true

vim.opt.autowrite = true
vim.opt.autowriteall = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.wrap = false
vim.opt.breakindent = true

vim.opt.mouse = ""
vim.opt.mousemodel = "extend"

vim.opt.showmode = false -- already shown in statusline

vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

vim.opt.conceallevel = 2

vim.opt.confirm = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = false -- don't highlight previous searches
vim.opt.inccommand = "split" -- preview substitutions live

vim.opt.updatetime = 200
vim.opt.timeoutlen = vim.g.vscode and 1000 or 300

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

-- case-insensitive searching unless \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.scrolloff = 10

vim.opt.smoothscroll = true

vim.opt.foldmethod = "expr"
vim.opt.foldlevel = 99
vim.opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
-- vim.opt.foldtext = ""

vim.opt.termguicolors = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.guicursor =
	"n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

vim.opt.winborder = "rounded"

vim.opt.cmdheight = 0

vim.opt.spelllang = { "en_gb", "de_de" }
vim.opt.spell = false
