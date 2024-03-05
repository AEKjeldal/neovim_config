local constants        = require('workspace_importer.constants')


local M = {}
M.outputWindow = nil
M.defaultBuffer = nil

local term_window_visible=function()
	if not (type(M.outputWindow) == 'number') then
		return false
	end
	return vim.api.nvim_win_is_valid(M.outputWindow)
end


M.replaceBuffer = function(new_buffer)
	M.defaultBuffer = new_buffer
	if term_window_visible() then
		vim.notify("Buffer replaced")
		vim.api.nvim_win_set_buf(M.outputWindow,new_buffer)
	end
end

M.toggle_term_window = function()
	if not term_window_visible() then
		M.open_term_window(M.defaultBuffer)
		return
	end
	vim.api.nvim_win_close(M.outputWindow,{force=true})
end

M.open_term_window = function(output_buffer,height)

	if not term_window_visible() then
		local curr_win = vim.api.nvim_get_current_win()

		height = height or 10 -- set a default
		vim.cmd("bel "..height.."split")
		M.outputWindow = vim.api.nvim_get_current_win() -- we are now in termwindow

		vim.api.nvim_set_current_win(curr_win)
	end

	-- TODO consider only running if output buffer is given=
	vim.api.nvim_win_set_buf(M.outputWindow,output_buffer)
end


-- Usable for floating windows
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





return M
