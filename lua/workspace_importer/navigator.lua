local plenary   = require('plenary')
local utilities = require('workspace_importer.utilities')

local M = {}

local function find_workspaceFiles(dir)
	-- local files = plenary.scandir.scan_dir(dir..'/**/*.code-workspace', {depth=5})
	local files = plenary.scandir.scan_dir(dir, {depth=10})
	local result = {}
	for _,file in pairs(files) do 
		if string.find(file,"code%-workspace") then
			table.insert(result,file)
		end
	end
	return result
end


local function get_parent(paths)
	local result = nil
	local max_depth = 1000
	for _,path in pairs(paths) do
		local path_split = utilities.str_split(path,utilities.sep())
		if #path_split < max_depth then
			result = path
			max_depth = #path_split
		end
	end
	return result
end


local function find_project_root(dir)

    dir = dir or vim.fn['getcwd']()
	local project_roots = vim.fs.find({'.git','.gitignore'},{
		upward=true,
		limit=5,
	    path = dir})

	local paths = {}
	for _,root in pairs(project_roots) do

		local path_split = utilities.str_split(root,utilities.sep())
		local path = '/'..table.concat(path_split,utilities.sep(),1,#path_split-1)

		table.insert(paths,path)
	end
	return get_parent(paths)
end


M.find_workspaces = function(dir)

  local project_root = find_project_root(dir)
  local workspaces = find_workspaceFiles(project_root)

  local result = {}

  for _,workspace in pairs(workspaces) do
	  -- if not directory then is file?
	  local filename = utilities.str_split(workspace,utilities.sep())
	  table.insert(result,{filename=filename[#filename], path=workspace})
  end
  return result

end

M.go_to_workspace = function(workspace)
	local path_split = utilities.str_split(workspace,utilities.sep())
	local path = '/'..table.concat(path_split,utilities.sep(),1,#path_split-1)

	vim.api.nvim_set_current_dir(path)
end


return M
