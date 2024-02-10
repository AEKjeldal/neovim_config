local builin = require('telescope.builtin')
local actions = require('telescope.actions')


-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
require('telescope').setup {
	defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
		  -- ctrlq sends to qflist and opens it
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist
      }
    },
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
-- require('telescope').load_extension('fzf')









vim.keymap.set('n','<C-p>',builin.find_files,{})
vim.keymap.set('n','<C-p>',function()

	local files = require('workspace_importer').constants.imported_paths

	print(vim.inspect(files))

	builin.find_files({search_dirs=files})

end)

vim.keymap.set('n','<C-b>',builin.git_branches,{})
vim.keymap.set('n','<leader>f',builin.live_grep,{})
vim.keymap.set('n','<leader>b',builin.buffers,{})

vim.keymap.set('n','<C-f>',function()
	builin.grep_string({ search = vim.fn.expand("<cword>") })
end)

