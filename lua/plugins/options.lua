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

	{
		'Yggdroot/LeaderF',
		cmd = {'Leaderf'},
		enabled = function()
			if vim.fn.has('python3') == 0 then
				return false
			end
			return true
		end,
		dependencies = {
			'tamago324/LeaderF-filer',
			'voldikss/LeaderF-emoji',
		},
		config = function () 
			vim.g.lf_disable_normal_map = 0
			inc('site/bundle/leaderf.vim')
		end,
	},
}


