local dap   = require('dap')
local dapui = require('dapui')

require('dap.ext.vscode').json_decode = require'json5'.parse

dapui.setup()

vim.keymap.set('n','<leader>dl', dapui.toggle)
vim.keymap.set('n','<leader>dc', dap.continue)
vim.keymap.set('n','<leader>dr', dap.restart)
vim.keymap.set('n','<leader>do', dap.step_over)
vim.keymap.set('n','<leader>di', dap.step_into)
vim.keymap.set('n','<leader>du', dap.step_out)
vim.keymap.set('n','<leader>db', dap.toggle_breakpoint)

dap.listeners.before.attatch.dapui_config = function()
	dapui.open()
end

dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end

local function venv_path()
	if os.getenv('OS') == 'Windows_NT' then
		return '~/.virtualenvs/debugpy/Scripts/python.exe'
	else
		return '~/.virtualenvs/debugpy/bin/python'
	end
end

local function debugpy_install_package()
	local venv = venv_path()
	vim.ui.input({prompt = 'Enter package to install: '}, function(input)
		if not input then return end

		print()
		print('Installing package: '..input)
		vim.fn.jobstart(venv..' -m pip install '..input)
	end)
end

vim.keymap.set('n','<leader>da', debugpy_install_package)

require('dap-python').setup(venv_path())
