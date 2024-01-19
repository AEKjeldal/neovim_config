local json5 = require('json5')
local dap = require('dap')


local M = {}
M.imported_paths = {}

local function find_workspaces(dir)
  dir = dir or vim.fn['getcwd']()

  local workspaces = {}

  if vim.fn.isdirectory(dir) > 0 then
	  for i,file in pairs(vim.fn.readdir(dir)) do
		  if vim.fn.isdirectory(dir..'\\'..file) > 0 and file == 'vc_workspace' then

			  for i,workspace in pairs(vim.fn.readdir(dir..'\\'..file)) do
				  -- if not directory then is file?
				  if vim.fn.isdirectory(dir..'\\'..file..'\\'..workspace) == 0 then
					  table.insert(workspaces,{filename =workspace, path = dir..'\\'..file..'\\'..workspace})
				  end
			  end
		  end
	  end
  end

  return workspaces
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

local function str_split(inputstr,seperator)
	-- either use given seperator (regex) or whitespace
	seperator = seperator or "%s"
	local result = {}
	for str in string.gmatch(inputstr,'[^'..seperator.."]+") do
		table.insert(result,str)
	end
	return result
end


local function path_to_obj(content)
	local result = {}
	for _,folder in pairs(content.folders) do
		local path_split = str_split(folder.path,'/')
		result[path_split[#path_split]] = string.gsub(folder.path,'^..','')
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
					config[opt] =  string.gsub(confstr,"${workspaceFolder:%w+}",'${workspaceFolder}'..named_paths[replaceStr])
				end
			end
		end
	end
	return config
end

local function set_paths(named_paths)
	for _,path in pairs(named_paths) do
		print(path)
	end

end



M.import_workspace = function(dir)
	local workspaces = find_workspaces(dir)

	vim.ui.select(workspaces, {
		prompt = 'Select file:',
		format_item = function(item)
			return  vim.inspect(item.filename)
		end,
	}, function(choice)
		pick = choice
	end)

	if not pick then
		return
	end

	local content = json_parse(load_file(pick['path']))
	config_formatted = format_config(content,path_to_obj(content))
	set_paths(path_to_obj(content))

	for _,conf in pairs(config_formatted.launch.configurations) do
		table.insert(dap.configurations.python,conf)
	end
end

-- M.import_workspace()
return M
