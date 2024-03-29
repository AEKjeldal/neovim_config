local buffer =  require('script_runner.buffers')
local ui	 =  require('script_runner.ui')

M = {}


M.buffer = buffer

M.toggle_window =  function(title)
	title = title or buffer.selected_window
	local bufno = buffer.active_buffers[title]

	if not (bufno and vim.api.nvim_buf_is_valid(bufno)) then
		buffer.setup_buffer(title)
	end
	ui.activate_buffer(title)
end

M.term_buffer = function(term_name)
	term_name = term_name or buffer.selected_window

	-- TODO tmp fix; should chek if buffer is term
	if not buffer.active_buffers[term_name] then
		M.buffer.term_buffer(term_name)
	end
	ui.activate_buffer(term_name)
end



M.buffer.winopts =  M.winopts or {
	relative = 'editor',
	width= math.ceil(vim.api.nvim_get_option("columns")),
	height= 20,
	row = math.ceil(vim.api.nvim_get_option("lines")-21),
	col = math.ceil(vim.api.nvim_get_option("columns")/3),
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

M.exclude_mask = function(exclude)
	local mask = {}
	exclude = exclude or {}
	table.foreach(exclude,function(idx,elem)
		mask[elem] = true
	end)
	return mask

end

M.picker_options = function(exclude)
	local exclude_mask = M.exclude_mask(exclude)
	local buffer_names = {}

	table.foreach(buffer.active_buffers , function(name,_bufno)
		if not exclude_mask[name] then
			table.insert(buffer_names,name)
		end
	end)

	return buffer_names
end


M.open_picker = function()
	buffer.setup_buffer('picker')
	local wintype = 'picker'
	local bufno = buffer.active_buffers['picker']
	vim.api.nvim_buf_set_lines(bufno,0,-1,false,M.picker_options({'picker'}))



	local winopts = {
	relative='editor',
	style = 'minimal',
	width  = 20,
	height = 10,
	noautocmd=true,
	row = math.ceil(vim.api.nvim_get_option("lines")/2)-math.ceil(10/2),
	col = math.ceil(vim.api.nvim_get_option("columns")/2)-math.ceil(20/2),
	}


	ui.activate_buffer('picker',winopts,wintype)
	vim.api.nvim_create_autocmd("CursorHold", {
		callback = function()
			local pos = vim.api.nvim_win_get_cursor(0)[1]
			local title = vim.api.nvim_buf_get_lines(bufno,pos-1,pos,true)[1]
			ui.activate_buffer(title)
			local winno = buffer.active_windows[wintype]
			vim.api.nvim_set_current_win(winno)
		end,
		-- clear handled in active_buffers()
		group = vim.api.nvim_create_augroup("script_runner_"..wintype,{clear = false}),
		buffer = bufno
	})

	vim.keymap.set('n', '<cr>', function()
		local pos = vim.api.nvim_win_get_cursor(0)[1]
		local sel_title = vim.api.nvim_buf_get_lines(bufno,pos-1,pos,true)[1]
		ui.activate_buffer(sel_title)
		buffer.hide_buffer(wintype,title)
	end,
	{ silent = true, buffer = bufno })
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
