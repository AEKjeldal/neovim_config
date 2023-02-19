local M = {}


-- type: bufno
M.active_buffers = {}

M.active_windows = {}


M.hide_buffer = function(wintype,bufname)

	local winno = M.active_windows[wintype]
	-- check window is active
	if winno then
		vim.api.nvim_win_hide(winno)
		-- window is removed, remove from list
		M.active_windows[wintype]=nil
	end

end


M.term_buffer = function(title)

	local bufno = M.active_buffers[title]
	if not (bufno and vim.api.nvim_buf_is_valid(bufno)) then
		M.setup_buffer(title)
		bufno = M.active_buffers[title]
		vim.api.nvim_buf_call(bufno,vim.cmd.term)
	end
	vim.api.nvim_buf_call(bufno,function ()
		-- This setting did not work with the lua api
		vim.cmd('tnoremap <buffer> <Esc> <C-\\><C-n>')
	end)
	vim.api.nvim_buf_call(bufno,vim.cmd.startinsert)

end


M.activate_buffer = function(title,winopts,wintype)
	winopts =  winopts or M.winopts
	wintype = wintype or 'main'

	local bufno = M.active_buffers[title]
	local winno = M.active_windows[wintype] 

	if not winno then
		print('creating: '.. wintype)
		winno = vim.api.nvim_open_win(bufno,true,winopts)
		M.active_windows[wintype] = winno
	else
		print('updating: '.. wintype)
		vim.api.nvim_win_set_buf(winno,bufno)
	end

	vim.api.nvim_create_autocmd("BufLeave", {
		callback = function()
			M.hide_buffer(wintype,title)
		end,
		group = vim.api.nvim_create_augroup("script_runner_"..wintype, {clear = true}),
		buffer = bufno
	})

	-- vim.keymap.set('n', '<esc>',M.hide_buffer,{ silent = true, buffer = bufno })
	vim.keymap.set('n', '<esc>', function()
		M.hide_buffer(wintype,title)
	end,
	{ silent = true, buffer = bufno })
end

M.setup_buffer = function(title)
	local bufno = vim.api.nvim_create_buf(false,false)
	vim.api.nvim_buf_set_option(bufno,'buftype','nofile')
	M.active_buffers[title] = bufno
end

return M




	--     vim.keymap.set('n', '<cr>',function()
	-- 	local buf = vim.api.nvim_get_current_buf()
	-- 	local sel = vim.api.nvim_get_current_line()
	-- 	local script = vim.g.runners[sel]
	--
	-- 	vim.fn.jobstart(script,{
	-- 		-- stdout_buffered=true,
	-- 		on_stdout = function(_,data)
	-- 			if data then
	-- 				vim.api.nvim_buf_set_lines(bufno,-1,-1,false,data)
	-- 			end
	-- 		end,
	--
	-- 		on_stderr = function (_,data)
	-- 			if not table.empty(data) then
	-- 				vim.api.nvim_buf_set_lines(bufno,-1,-1,false,{'error:'})
	-- 				vim.api.nvim_buf_set_lines(bufno,-1,-1,false,data)
	-- 			end
	-- 		end
	-- 	}
	-- 	)
	-- end,
	-- { silent = true, buffer = bufno })
