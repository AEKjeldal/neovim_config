

vim.g.mapleader = ' '
vim.keymap.set('n','<leader>pv',vim.cmd.Ex)

-- move visual selection up or down
vim.keymap.set('v','J',":m '>+1<CR>gv=gv")
vim.keymap.set('v','K',":m '<-2<CR>gv=gv")

vim.keymap.set('n', '<leader>y', "\"+y")
vim.keymap.set('v', '<leader>y', "\"+y")
vim.keymap.set('n', '<leader>Y', "\"+Y")
vim.keymap.set('n', '<C-s>', ":w<cr>")

-- experimental
vim.keymap.set('n','<leader>1',function()
	require('script_runner').open_picker()
end)

vim.keymap.set('n','<leader>t',function()
	require('script_runner').term_buffer()
end)

vim.keymap.set('n','<leader>T',function()
	require('script_runner').term_buffer(vim.fn.input('input term name: '))
end)



