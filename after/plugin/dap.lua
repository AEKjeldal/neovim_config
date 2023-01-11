dap = require('dap')



vim.keymap.set('n','<leader>dc', dap.continue)
vim.keymap.set('n','<leader>do', dap.step_over)
vim.keymap.set('n','<leader>di', dap.step_into)
vim.keymap.set('n','<leader>du', dap.step_out)
vim.keymap.set('n','<leader>db', dap.toggle_breakpoint)



local dap = require('dap')

dap.adapters.python = {
	type = 'executable',
	command = 'python',
	args = {'-m', 'debugpy.adapter'}
}

dap.configurations.python = {

	{
		type = 'python',
		require = 'launch',
		name = "Launch file",
		program = "${file}",
		pythonPath = function() return '/usr/bin/python' end,
	},

}
