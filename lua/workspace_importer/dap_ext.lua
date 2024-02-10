
local dap       = require('dap')
local constants = require('workspace_importer.constants')

local M = {}

M.continue = function()

	if not dap.status() then
		print("not status")
		dap.continue()
	end

	-- print('Configuration')
	local configurations = constants.configurations


	-- TODO fix to be filetype dependend!
	for _,ft in pairs(dap.configurations) do
		for _,conf in pairs(ft) do
			table.insert(configurations,conf)
		end
	end

	-- get filetype
	local select = {}
	vim.ui.select(configurations, {
		prompt = 'Select conf:',
		format_item = function(conf)
			return  vim.inspect(conf['name'])
		end,
	}, function(choice)
		select = choice
	end)

	if  not select then
		return
	end

	dap.run(select)
	-- print(vim.inspect(constants.configurations))


	-- local status = dap.status()
	-- if status ~="" then
	-- 	print('dap active, status: '..status)
	-- 	print(vim.inspect(status))
	-- 	-- dap.continue()
	-- else
	-- 	print()
	-- 	-- print(vim.inspect(constants))
		-- print(vim.inspect(require('workspace_importer.constants')))

		-- local configurations = constants.get_configuraions()
		-- local select

		-- for _,conf in pairs(dap.configurations) do
		-- 	print('##################################################')
		-- 	print(vim.inspect(conf))
		-- 	table.insert(configurations,conf)
		-- end
		--
		-- vim.ui.select(configurations, {
		-- 	prompt = 'Select conf:',
		-- 	format_item = function(item)
		-- 		return  vim.inspect(item['filename'])
		-- 	end,
		-- }, function(choice)
		-- 	select = choice
		-- end)

	-- end
end

M.print_stuff = function()
	print('Configuration')
	print(vim.inspect(constants.configurations))
	print('Paths')
	print(vim.inspect(constants.imported_paths))
	print(#constants.imported_paths.." <++> "..#constants.configurations)
end

return M
