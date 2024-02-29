local json5 = require('json5')

local M = {}

M.copy = function(original)
	local copy = {}
	for key,value in pairs(original) do
		copy[key] = value
	end
	return  copy
end

M.str_split = function (inputstr,seperator)
	-- either use given seperator (regex) or whitespace
	seperator = seperator or "%s"
	local result = {}
	for str in string.gmatch(inputstr,'[^'..seperator.."]+") do
		table.insert(result,str)
	end
	return result
end

M.sep = function()
	if os.getenv('OS') == 'Windows_NT' then
		return '\\'
	else
		return '/'
	end
end


M.uniq = function(list)
	local result = {}
	local seen = {}

	for _,elem in pairs(list) do
		if not seen[elem] then
			seen[elem] = true
			table.insert(result,elem)
		end
	end
	return result
end


local function load_file(filename)
	local file = io.input(filename)
	return file:read("*a")
end

M.json_parse = function(filename)
	return json5.parse(load_file(filename))
end

M.format_config = function(config,named_paths)

	for _,config in pairs(config.launch.configurations) do
		for opt in pairs(config) do
			local confstr = config[opt]

			if type(confstr) == 'string' then
				local _,_,replaceStr =  string.find(confstr,'${workspaceFolder:(%w+)}')

				if replaceStr ~=nil then
					config[opt] =  string.gsub(confstr,"${workspaceFolder:%w+}",'${workspaceFolder}'..M.sep()..named_paths[replaceStr])
				end
			end
		end
	end

	return config

end


M.path_to_obj = function(content)
	local result = {}
	for _,folder in pairs(content.folders) do
		local path_split = M.str_split(folder.path,'/')
		result[path_split[#path_split]] = folder.path
	end
	return result
end


M.prompt_user = function(workspaces)
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

return M
