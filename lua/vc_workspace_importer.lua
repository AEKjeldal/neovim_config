local json5 = require('json5')
local dap = require('dap')
local plenary = require('plenary')

local function sep()
	if os.getenv('OS') == 'Windows_NT' then
		return '\\'
	else
		return '/'
	end
end


local M = {}
M.imported_paths = {}

local function str_split(inputstr,seperator)
	-- either use given seperator (regex) or whitespace
	seperator = seperator or "%s"
	local result = {}
	for str in string.gmatch(inputstr,'[^'..seperator.."]+") do
		table.insert(result,str)
	end
	return result
end

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
local function find_workspaces(dir)


  dir = dir or vim.fn['getcwd']()
  local workspaces = find_workspaceFiles(dir)
  local result = {}

  for i,workspace in pairs(workspaces) do
	  -- if not directory then is file?
	  local filename = str_split(workspace,sep())
	  table.insert(result,{filename=filename[#filename], path=workspace})
  end
  return result
end


local function load_file(filename)
	local file = io.input(filename)
	return file:read("*a")
end

------ Problem is that we need a json5 dataformatter 
--	   find a solution of how to add this in w#!*%$ws
local function json_parse(content)
	return json5.parse(content)
end


local function path_to_obj(content)
	local result = {}
	for _,folder in pairs(content.folders) do
		local path_split = str_split(folder.path,'/')
		result[path_split[#path_split]] = folder.path
	end
	return result
end

local function format_config(config,named_paths)
	for _,config in pairs(config.launch.configurations) do
		for opt in pairs(config) do
			local confstr = config[opt]
			if type(confstr) == 'string' then
				local _,_,replaceStr =  string.find(confstr,'${workspaceFolder:(%w+)}')
				if replaceStr ~=nil then
					config[opt] =  string.gsub(confstr,"${workspaceFolder:%w+}",'${workspaceFolder}'..sep()..named_paths[replaceStr])
				end
			end
		end
	end
	return config
end

local function set_paths(named_paths)
	local paths = {}
	for _,path in pairs(named_paths) do
		table.insert(paths,path)
	end
	M.imported_paths = paths
end


local function prompt_user(workspaces)
	local result
	vim.ui.select(workspaces, {
		prompt = 'Select file:',
		format_item = function(item)
			return  vim.inspect(item['filename'])
		end,
	}, function(choice)
		result = choice
	end)
	return result
end

local function go_to_workspace(workspace)
	local path_split = str_split(workspace,sep())
	local path = '/'..table.concat(path_split,sep(),1,#path_split-1)
	vim.api.nvim_set_current_dir(path)
end


M.import_workspace = function(dir)
	local workspaces = find_workspaces(dir)
	local pick = prompt_user(workspaces)

	if not pick then
		return
	end

	go_to_workspace(pick['path'])
	local content = json_parse(load_file(pick['path']))

	local config_formatted = format_config(content,path_to_obj(content))
	set_paths(path_to_obj(content))

	for _,conf in pairs(config_formatted.launch.configurations) do
		table.insert(dap.configurations.python,conf)
	end
end
return M
