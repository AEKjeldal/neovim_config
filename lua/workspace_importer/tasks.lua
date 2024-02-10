constants        = require('workspace_importer.constants')
builtin_runners  = require('workspace_importer.builtin_runners')




M = {}
M.output_buffer = nil
M.trigger_on_save = nil
M.term_window = nil


local term_window_visible=function()
	if not (type(M.term_window) == 'number') then
		return false
	end
	return vim.api.nvim_win_is_valid(M.term_window)
end

local open_term_window = function(output_buffer,height)
	if not term_window_visible() then
		local curr_win = vim.api.nvim_get_current_win()
		height = height or 10 -- set a default
		vim.cmd("bel "..height.."split")
		M.term_window = vim.api.nvim_get_current_win() -- we are now in termwindow
		vim.api.nvim_set_current_win(curr_win)
	end

	-- TODO consider only running if output buffer is given=
	vim.api.nvim_win_set_buf(M.term_window,output_buffer)
end

M.toggle_term_window = function()
	if not term_window_visible() then
		open_term_window(M.output_buffer)
		return
	end
	vim.api.nvim_win_close(M.term_window,{force=true})
end

local get_new_output_buffer = function()

	local output_buffer_old  = M.output_buffer

	M.output_buffer = vim.api.nvim_create_buf(false,true)
	if term_window_visible() then -- Replace old buffer before deleting
		vim.api.nvim_win_set_buf(M.term_window,M.output_buffer)
	end

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
	open_term_window(output_buffer)

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
			vim.api.nvim_buf_call(M.output_buffer, function()vim.cmd.normal("G") end)
		end,
		on_stderr = function(job_id, data)
			-- Print stderr to the terminal buffer in red
			vim.api.nvim_buf_call(M.output_buffer, function()vim.cmd.normal("G") end)
		end
})

end

M.run_tests = function(once)
	local python_tests = builtin_runners.python.test
	M.run_task(python_tests[1],once)
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
