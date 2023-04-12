local dap = require('dap')
local dapui = require('dapui')

dapui.setup()

vim.keymap.set('n','<leader>dl', dapui.toggle)
vim.keymap.set('n','<leader>dc', dap.continue)
vim.keymap.set('n','<leader>do', dap.step_over)
vim.keymap.set('n','<leader>di', dap.step_into)
vim.keymap.set('n','<leader>du', dap.step_out)
vim.keymap.set('n','<leader>db', dap.toggle_breakpoint)


local home = os.getenv('HOME') or os.getenv('USERPROFILE')

-- if os.getenv('OS') == 'Windows_NT' then
-- 	home = os.getenv('USERPROFILE')
-- end
local function get_adapter()
	if os.getenv('OS') == 'Windows_NT' then
		return home .. '/.virtualenvs/debugpy/Scripts/python'
	else
		return home .. '/.virtualenvs/debugpy/bin/python'
	end
end

local home = os.getenv("HOME") or os.getenv('USERPROFILE')
dap.adapters.python = {
	type = 'executable',
    command = get_adapter(),
	args = {'-m', 'debugpy.adapter'}
}

local function get_pythonPath()

	local cwd = vim.fn.getcwd()
	if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
		return cwd .. '/venv/bin/python'

	elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
		return cwd .. '/.venv/bin/python'

	elseif vim.fn.executable(home ..'/.virtualenvs/debugpy/Scripts/Python') == 1 then
		return home ..'/.virtualenvs/debugpy/Scripts/Python'
		-- C:\Users\Anders E Kjeldal\.virtualenvs
	elseif vim.fn.executable(home ..'/.virtualenvs/debugpy/Scripts/Python') == 1 then
		return home ..'/.virtualenvs/debugpy/Scripts/Python'
	else
		if os.getenv('OS') == 'Windows_NT' then
			-- return os.getenv('USERPROFILE')..'\\Local\\Microsoft\\WindowsApps\\Python3.8.exe'
			return os.getenv('USERPROFILE').."\\AppData\\Local\\Microsoft\\WindowsApps\\python3.8.exe"
			--"\\AppData\\Local\\Microsoft\\WindowsApps\\PythonSoftwareFoundation.Python.3.8_qbz5n2kfra8p0"
				--  "C:\Users\Anders\ E\ Kjeldal\\AppData\\Local\\Microsoft\\WindowsApps\\python3.8.exe"
		else
			return '/usr/bin/python3'
		end
	end
end

dap.configurations.python = {
	{
		-- The first three options are required by nvim-dap
		type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
		request = 'launch';
		name = "Launch file";
		-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
		program = "${file}"; -- This configuration will launch the current file if used.
		pythonPath = get_pythonPath()
	},
	{
		-- The first three options are required by nvim-dap
		type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
		request = 'launch';
		name = "pytest";
		-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
		runtimeArgs = {'-m','pytest', 'test/'},
		pythonPath = function()
			-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
			-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
			-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
			local cwd = vim.fn.getcwd()
			if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
				return cwd .. '/venv/bin/python'
			elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
				return cwd .. '/.venv/bin/python'
			else
				return 'pytest'
			end
		end;
	},
}




