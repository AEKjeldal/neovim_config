
local builin = require('telescope.builtin')

vim.keymap.set('n','<C-p>',builin.find_files,{})
vim.keymap.set('n','<leader>f',builin.live_grep,{})

vim.keymap.set('n','<C-f>',function()
	builin.grep_string({ search = vim.fn.expand("<cword>") })
end)

-- vim.keymap.set('n','<leader>f',function()
-- 	builin.grep_string({ search = vim.fn.input("Grep: ") })
-- end)

