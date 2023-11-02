local buffer =  require('script_runner.buffers')

local M = {}

M.active_windows = {}
buffer.active_windows = M.active_windows

local function width()
	return math.ceil(vim.api.nvim_get_option("columns"))
end

local function row(offset)
	offset = offset or 21
	return math.ceil(vim.api.nvim_get_option("lines")-offset)
end

local function col(divsor)
	divsor = divsor or 3
	return math.ceil(vim.api.nvim_get_option("columns")/divsor)
end



local function get_winopts(type)
	if type=='picker' then
		return {
			relative='editor',
			style = 'minimal',
			width  = 20,
			height = 10,
			noautocmd=true,
			row = math.ceil(vim.api.nvim_get_option("lines")/2)-math.ceil(10/2),
			col = math.ceil(vim.api.nvim_get_option("columns")/2)-math.ceil(20/2),
		}
	else
		return {
			relative = 'editor',
			width= math.ceil(vim.api.nvim_get_option("columns")),
			height= 20,
			row = math.ceil(vim.api.nvim_get_option("lines")-21),
			col = math.ceil(vim.api.nvim_get_option("columns")/3),
			style = 'minimal',
			border = 'double',
		}
	end

end






M.activate_buffer = function(title,winopts,wintype)
	-- winopts =  winopts or M.winopts()
	winopts = get_winopts(wintype)

	wintype = wintype or 'main'

	local bufno = buffer.get_active_buffer(title)

	local winno = M.active_windows[wintype]

	if not winno then
		winno = vim.api.nvim_open_win(bufno,true,winopts)
		M.active_windows[wintype] = winno
	else
		vim.api.nvim_win_set_buf(winno,bufno)
	end

	vim.api.nvim_create_autocmd("BufLeave", {
		callback = function()
			buffer.hide_buffer(wintype,title)
		end,
		group = vim.api.nvim_create_augroup("script_runner_"..wintype,
		{clear = true}),
		buffer = bufno
	})

	vim.keymap.set('n', 'q', function()
		M.hide_buffer(wintype,title)
	end,
	{ silent = true, buffer = bufno })
	-- vim.keymap.set('n', '<esc>',M.hide_buffer,{ silent = true, buffer = bufno })
	vim.keymap.set('n', '<esc>', function()
		buffer.hide_buffer(wintype,title)
	end,
	{ silent = true, buffer = bufno })
	M.selected_window = title
end

return M
