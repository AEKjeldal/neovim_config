local constants        = require('workspace_importer.constants')
local builtin_runners  = require('workspace_importer.builtin_runners')
local ui               = require('workspace_importer.ui')


M = {}
M.output_buffer   = nil
M.trigger_on_save = nil
M.named_buffers = {}


M.toggle_term_window = function()
	ui.toggle_term_window()
end

local get_new_output_buffer = function()

	local output_buffer_old  = M.output_buffer

	M.output_buffer = vim.api.nvim_create_buf(false,true)
	vim.notify("Building new output buffer")

	ui.replaceBuffer(M.output_buffer)
	-- if term_window_visible() then -- Replace old buffer before deleting
	-- 	vim.notify("Terminal Window is visible!")
	-- 	vim.api.nvim_win_set_buf(ui.outputWindow,M.output_buffer)
	-- end

	if output_buffer_old then
		-- kill old buffer
		vim.api.nvim_buf_delete(output_buffer_old,{ force= true})
	end
	return M.output_buffer
end

local function clear_group()
	return vim.api.nvim_create_augroup("TestRunners",{clear=true})
end


local function trigger_on_save(output_buffer,callback)
	M.trigger_on_save = true
	-- Trigger task on save!
	local id = clear_group()
	vim.api.nvim_create_autocmd({"BufWritePost"}, {
		-- TODO: implement to match filetype
		-- pattern = {"*.c", "*.h"}, 
		group=id,
		callback = function()

			M.output_buffer = get_new_output_buffer()
			vim.api.nvim_buf_call(M.output_buffer,callback)
		end
	})
end

M.run_task = function(task,once)
	local output_buffer = get_new_output_buffer()
	local trigger = task.trigger or 'called'

	if trigger == 'onSave' and not once then

		vim.api.nvim_buf_call(output_buffer,function() M.run_task_term(task) end)
		trigger_on_save(output_buffer, function() M.run_task_term(task) end)
		return
	end
	ui.open_term_window(output_buffer)

	vim.api.nvim_buf_call(output_buffer,function() M.run_task_term(task) end)
end

M.run_task_term = function(task)
	-- vim.api.nvim_open_win(output_buffer,true,get_winopts())
	local workdir = task.working_directory or vim.fn['getcwd']()
	local command = { task.command }
	for _,arg in pairs(task.args) do
		table.insert(command,arg)
	end

	local handle = vim.fn.termopen(command,{
		cwd = workdir,
		on_stdout = function(job_id, data)
			vim.api.nvim_buf_call(M.output_buffer, function() vim.cmd.normal("G") end)
		end,
		on_stderr = function(job_id, data)
			-- Print stderr to the terminal buffer in red
			vim.api.nvim_buf_call(M.output_buffer, function() vim.cmd.normal("G") end)
		end
})

end

M.run_tests = function(once)
	local filetype = vim.bo.filetype
	local tasks = builtin_runners[filetype]

	if tasks and tasks.test then
		M.run_task(task.test[1],once)
	else
		print('no tests found for filetype: '..filetype)
	end
end

M.toggle_autotest = function()
	if M.trigger_on_save then
		clear_group()
		M.trigger_on_save = false
	else
		M.trigger_on_save = true
		M.run_tests(false)
	end
	vim.notify('Toggeling Automatic test: '..vim.inspect(M.trigger_on_save))
end

return M
