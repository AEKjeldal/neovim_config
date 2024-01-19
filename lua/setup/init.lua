require("setup.remap")
require("setup.packer")


vim.cmd.colorscheme "catppuccin"
vim.opt.nu = true
vim.opt.rnu = true

vim.opt.ttimeoutlen=0

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.scrolloff = 8
vim.expandtab = true

vim.opt.swapfile = false
vim.opt.backup = false

local home  = os.getenv("HOME") or os.getenv('USERPROFILE')
vim.opt.undodir = home .. "/.vim.undodir"

vim.opt.undofile = true


vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"

vim.opt.wrap = false

vim.diagnostic.show()






local powershellOpts = {
  shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
  shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
  shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
  shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
  shellquote = "",
  shellxquote = "",
}


if os.getenv('USERPROFILE') then
	for opt,value in pairs(powershellOpts) do
		vim.opt[opt] = value
	end
end





