local utils = require('core.utils')
local inc = utils.include_script

return {
	{'tpope/vim-fugitive', config = function() inc('site/bundle/git.vim') end },
	'tpope/vim-rhubarb',
	'tpope/vim-unimpaired',
	{'justinmk/vim-dirvish', config = function() inc('site/bundle/dirvish.vim') end },
	{'bootleq/vim-cycle', config = function() inc('site/bundle/dirvish.vim') end },
	

	{
		't9md/vim-choosewin',
		config = function()
			vim.keymap.set('n', '<m-e>', '<Plug>(choosewin)', {})
		end,
	},

	'tommcdo/vim-exchange', 
	'tommcdo/vim-lion',
	'skywind3000/vim-dict',

	{
		'terryma/vim-expand-region',
		config = function()
			vim.keymap.set({'n', 'v'}, '<m-+>', '<Plug>(expand_region_expand)', {})
			vim.keymap.set({'n', 'v'}, '<m-->', '<Plug>(expand_region_shrink)', {})
		end,
	},
}


