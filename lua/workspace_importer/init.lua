local dap = require('dap')

local navigator =  require('workspace_importer.navigator')
local utilities =  require('workspace_importer.utilities')

local M = {}
M.constants =  require('workspace_importer.constants')
M.dap =  require('workspace_importer.dap_ext')
M.tasks =  require('workspace_importer.tasks')

local function set_paths(named_paths)
	local paths = {}
	for _,path in pairs(named_paths) do
		table.insert(paths,path)
	end
	M.constants.imported_paths = paths
end

M.import_workspace = function(dir)
	local workspaces = navigator.find_workspaces(dir)
	local pick       = utilities.prompt_user(workspaces)

	if not pick then
		return
	end

	navigator.go_to_workspace(pick['path'])

	local content = utilities.json_parse(pick['path'])

	local config_formated = utilities.format_config(content,utilities.path_to_obj(content))
	set_paths(utilities.path_to_obj(config_formated))

	M.constants.configurations = config_formated.launch.configurations



	-- for _,conf in pairs(config_formated.launch.configurations) do
	-- 	table.insert(dap.configurations.python,conf)
	-- end

end


M.print_stuff = function()
	print('Configuration')
	print(vim.inspect(M.constants.configurations))
	print('Paths')
	print(vim.inspect(M.constants.imported_paths))
end

return M

