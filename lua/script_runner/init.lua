local buffer =  require('script_runner.buffers')

M = { 



}
M.buffer = buffer

M.toggle_window =  function(title)
	local bufno = buffer.active_buffers[title]
	if not (bufno and vim.api.nvim_buf_is_valid(bufno)) then
		buffer.setup_buffer(title)
	end
	M.buffer.activate_buffer(title)
end

M.term_buffer = function()
	M.buffer.term_buffer('term')
	M.toggle_window("term")
end



M.buffer.winopts =  M.winopts or {
	relative = 'editor',
	width= math.ceil(vim.api.nvim_get_option("columns")),
	height= 20,
	row = math.ceil(vim.api.nvim_get_option("columns")),
	col = math.ceil(vim.api.nvim_get_option("lines")/3),
	style = 'minimal',
	border = 'double',
}


local function prompt_script(runners,bufno)
	runner_names = {}
	table.foreach(runners, function(name,_)
		table.insert(runner_names,name)
	end)

	vim.api.nvim_buf_set_lines(bufno,0,-1,false,runner_names)

end




local function run_script(script,bnr)
	vim.fn.jobstart(script,{
		stdout_buffered=true,
		on_stdout = function(_,data)
			if data then
				vim.api.nvim_buf_set_lines(bnr,0,-1,false,data)
			end
		end,

		on_stderr = function (_,data)
			if not table.empty(data) then
				vim.api.nvim_buf_set_lines(bnr,-1,-1,false,{'error:'})
				vim.api.nvim_buf_set_lines(bnr,-1,-1,false,data)
			end
		end
	}
	)
end


local function setup_win()
 vim.api.nvim_win_set_option(winno,'rnu',false)
 vim.api.nvim_win_set_option(winno,'nu',false)
end



return M






-- local function setup_buffer()
-- 	bufno = vim.api.nvim_create_buf(false,false)
-- 	print('Setting up buffer: '..bufno)
-- 	vim.api.nvim_buf_set_option(bufno,'buftype','nofile')
-- 	vim.api.nvim_buf_call(bufno,vim.cmd.terminal)
-- 	vim.api.nvim_create_autocmd("BufLeave", {
-- 		callback = function()
-- 		if winno then
-- 			vim.api.nvim_win_hide(winno)
-- 		end
-- 		end,
-- 		group = vim.api.nvim_create_augroup("runner_group", {clear = true}),
-- 		buffer = bufno
-- 	})
--
--     vim.keymap.set('n', '<cr>',function()
-- 		local buf = vim.api.nvim_get_current_buf()
-- 		local sel = vim.api.nvim_get_current_line()
-- 		local script = vim.g.runners[sel]
--
-- 		vim.fn.jobstart(script,{
-- 			-- stdout_buffered=true,
-- 			on_stdout = function(_,data)
-- 				if data then
-- 					vim.api.nvim_buf_set_lines(bufno,-1,-1,false,data)
-- 				end
-- 			end,
--
-- 			on_stderr = function (_,data)
-- 				if not table.empty(data) then
-- 					vim.api.nvim_buf_set_lines(bufno,-1,-1,false,{'error:'})
-- 					vim.api.nvim_buf_set_lines(bufno,-1,-1,false,data)
-- 				end
-- 			end
-- 		}
-- 		)
-- 	end,
-- 	{ silent = true, buffer = bufno })
--
--     vim.keymap.set('n', '<esc>', function()
-- 		-- vim.api.nvim_buf_delete(bufno,{})
-- 		if winno then
-- 			vim.api.nvim_win_hide(winno)
-- 		end
--
-- 	end,
-- 	{ silent = true, buffer = bufno })
-- end
--
--
--
--
--
-- this will set buffer text = hej, hejsan, swaje erasing all other
--vim.api.nvim_buf_set_lines(bufno,0,-1,false,{'hej','hejsan','swaje'})
-- this will append buffer text to the start
-- vim.api.nvim_buf_set_lines(bufno,0,0,false,{'hej','hejsan','swaje'})
-- this will append buffer text to the end
-- vim.api.nvim_buf_set_lines(bufno,-1,-1,false,{'hej','hejsan','swaje'})
-- open_new_window()

