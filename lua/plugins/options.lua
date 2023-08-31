local utils = require('core.utils')
local custom = require('config.custom')
local package_enabled = utils.package_enabled
local inc = utils.include_script

return {
	{
		'itchyny/vim-cursorword',
		enabled = package_enabled('cursorword'),
		config = function()
			vim.g.cursorword_delay = 100
			vim.g.cursorword = 0
		end,
	},

	{
		'justinmk/vim-dirvish', 
		enabled = not package_enabled('oil'),
		config = function() 
			inc('site/bundle/dirvish.vim') 
		end 
	},
	
	{
		'stevearc/oil.nvim',
		enabled = package_enabled('oil'),
		config = function()
			require('oil').setup()
		end
	},
}


