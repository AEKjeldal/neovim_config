require("setup.remap")
require("setup.packer")

vim.opt.nu = true
vim.opt.rnu = true


vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.expandtab = true

vim.opt.swapfile = false
vim.opt.backup = false

local home  = os.getenv("HOME") or os.getenv('USERPROFILE')
vim.opt.undodir = home .. "/.vim.undodir"

vim.opt.undofile = true 


vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"

vim.opt.wrap = false
