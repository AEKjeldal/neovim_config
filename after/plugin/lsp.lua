local lsp = require('lsp-zero')
lsp.preset('recommended')
lsp.setup()

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings  = lsp.defaults.cmp_mappings({
	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
	['<tab>'] = cmp.mapping.confirm({ select = true }),
	--['<C-n>'] = cmp.mapping.complete(),
})


vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	float = {
		border = "single",
		-- format = function(diagnostic)
		-- 	return string.format(
		-- 		"%s (%s) [%s]",
		-- 		diagnostic.message,
		-- 		diagnostic.source,
		-- 		diagnostic.code or diagnostic.user_data.lsp.code
		-- 	)
		-- end,
	},
})





