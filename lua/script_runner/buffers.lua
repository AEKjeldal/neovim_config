local M = {}


-- type: bufno
M.active_buffers = {}


M.hide_buffer = function(winno)
	if winno then
		vim.api.nvim_win_hide(winno)
	end
end


M.term_buffer = function(title)

	local bufno = M.active_buffers[title]
	if not (bufno and vim.api.nvim_buf_is_valid(bufno)) then
		M.setup_buffer(title)
		bufno = M.active_buffers[title]
		vim.api.nvim_buf_call(bufno,vim.cmd.term)
	end
	-- vim.keymap.set('t','<Esc>','<C-\\><C-n>',{ buffer = bufno })


	print("settign up term_buffer for buffer:" .. bufno)
	vim.api.nvim_buf_call(bufno,function ()
		vim.cmd('tnoremap <buffer> <Esc> <C-\\><C-n>')
	end)
	vim.api.nvim_buf_call(bufno,vim.cmd.startinsert)

end

M.activate_buffer = function(title)
	local bufno = M.active_buffers[title]

	local winno = vim.api.nvim_open_win(bufno,true,M.winopts)

	vim.api.nvim_create_autocmd("BufLeave", {
		callback = function()
			M.hide_buffer(winno)
		end,
		group = vim.api.nvim_create_augroup("runner_group", {clear = true}),
		buffer = bufno
	})

	-- vim.keymap.set('n', '<esc>',M.hide_buffer,{ silent = true, buffer = bufno })
	vim.keymap.set('n', '<esc>', function()
		M.hide_buffer(winno)
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
