
-- Fix this to be a function when you have the time
local json5_install = ''
if os.getenv('OS') == 'Windows_NT' then
    json5_install = 'powershell ./install.ps1'
else
    json5_install = './install.sh'
end



-- Only required if you have packer configured as `opt`

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'
	use {
		'nvim-telescope/telescope.nvim', 
		-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

    use( 'godlygeek/tabular')

    -- use( 'preservim/vim-markdown')
    use( 'godlygeek/tabular')
    use( 'rcarriga/nvim-notify')

	use({'jakewvincent/mkdnflow.nvim',
	rocks = 'luautf8', -- Ensures optional luautf8 dependency is installed
	config = function()
		require('mkdnflow').setup()
	end
})
    use( 'lewis6991/gitsigns.nvim')


	use('epwalsh/obsidian.nvim')
	use('ThePrimeagen/harpoon')
	use('mbbill/undotree')
	use('tpope/vim-fugitive')
	use{'Joakker/lua-json5', run = './install.sh'}
	use('mhinz/vim-signify')
	use({'RaafatTurki/hex.nvim' })
	use('terrortylor/nvim-comment')
	use {"luukvbaal/nnn.nvim"}

	use {
	    'Joakker/lua-json5',
	    -- if you're on windows
		run = json5_install
	    -- run = function()
	    -- 		    if os.getenv('OS') == 'Windows_NT' then
	    -- 			    return 'powershell ./install.ps1'
	    -- 		    else
	    -- 			    return './install.sh'
	    -- 		    end
	    -- end
	}
	use { "catppuccin/nvim", as = "catppuccin" }

	use('mhinz/vim-signify')
	use({'RaafatTurki/hex.nvim' })
	use('terrortylor/nvim-comment')
	use {"luukvbaal/nnn.nvim"}
	use {'iamcco/markdown-preview.nvim'}

	use('nvim-treesitter/nvim-treesitter', {run  = ':TSUpdate'})
	use('nvim-treesitter/playground')
	use('nvim-treesitter/nvim-treesitter-context')
	use {
		'VonHeikemen/lsp-zero.nvim',
		requires = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},
			{'williamboman/mason.nvim'},
			{'williamboman/mason-lspconfig.nvim'},

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},
			{'hrsh7th/cmp-buffer'},
			{'hrsh7th/cmp-path'},
			{'saadparwaiz1/cmp_luasnip'},
			{'hrsh7th/cmp-nvim-lsp'},
			{'hrsh7th/cmp-nvim-lua'},

			-- Snippets
			{'L3MON4D3/LuaSnip'},
			-- Snippet Collection (Optional)
			{'rafamadriz/friendly-snippets'},
		}
	}

	use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }

	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}

	-- use{'puremourning/vimspector'}
	use {"mfussenegger/nvim-dap"}
	use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"}}
	use {'mfussenegger/nvim-dap-python'}
	use {
		"Dax89/automaton.nvim",
		requires = {
			{"nvim-lua/plenary.nvim"},
			{"nvim-telescope/telescope.nvim"},
			{"mfussenegger/nvim-dap"}, -- Debug support for 'launch' configurations (Optional)
			{"hrsh7th/nvim-cmp"},      -- Autocompletion for automaton workspace files (Optional)
			{"L3MON4D3/LuaSnip"},      -- Snippet support for automaton workspace files (Optional)
		}
	}
end)
