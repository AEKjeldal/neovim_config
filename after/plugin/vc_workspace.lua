
vc_importer = require('workspace_importer')

vim.keymap.set('n','<leader>vc',function()
	vc_importer.import_workspace()
end)

vim.keymap.set('n','<leader>vs',function()
	vc_importer.dap.continue()
end)

vim.keymap.set('n','<leader>wt',function()
	vc_importer.tasks.toggle_autotest()
end)
vim.keymap.set('n','<leader>wr',function()
	vc_importer.tasks.run_tests({once=true})
end)

vim.keymap.set('n','<leader>wi',function()
	vc_importer.tasks.toggle_term_window()
end)
