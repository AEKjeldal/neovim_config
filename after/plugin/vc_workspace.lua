
vc_importer = require('vc_workspace_importer')

vim.keymap.set('n','<leader>vc',function()
	vc_importer.import_workspace()
end)
