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

	{
		'godlygeek/tabular',
		keys = {
			{'gb=', ':Tabularize /=<cr>', mode = 'n'},
			{'gb=', ':Tabularize /=<cr>', mode = 'v'},
			{'gb/', ':Tabularize /\\/\\//l4c1<cr>', mode = 'n'},
			{'gb/', ':Tabularize /\\/\\//l4c1<cr>', mode = 'v'},
			{'gb*', ':Tabularize /\\/\\*/l4c1<cr>', mode = 'n'},
			{'gb*', ':Tabularize /\\/\\*/l4c1<cr>', mode = 'v'},
			{'gb,', ':Tabularize /,/r0l1<cr>', mode = 'n'},
			{'gb,', ':Tabularize /,/r0l1<cr>', mode = 'v'},
			{'gbl', ':Tabularize /\\|<cr>', mode = 'n'},
			{'gbl', ':Tabularize /\\|<cr>', mode = 'v'},
			{'gbc', ':Tabularize /#/l4c1<cr>', mode = 'n'},
			{'gbc', ':Tabularize /#/l4c1<cr>', mode = 'v'},
			{'gb<bar>', ':Tabularize /\\|<cr>', mode = 'n'},
			{'gb<bar>', ':Tabularize /\\|<cr>', mode = 'v'},
			{'gbr', ':Tabularize /\\|/r0<cr>', mode = 'n'},
			{'gbr', ':Tabularize /\\|/r0<cr>', mode = 'v'},
		},
	},

	{
		'justinmk/vim-sneak',
		keys = {
			{'gz', '<Plug>Sneak_s', mode = 'n'},
			{'gZ', '<Plug>Sneak_S', mode = 'n'},
			{'gz', '<Plug>Sneak_s', mode = 'v'},
			{'gZ', '<Plug>Sneak_S', mode = 'v'},
			{'gz', '<Plug>Sneak_s', mode = 'x'},
			{'gZ', '<Plug>Sneak_S', mode = 'x'},
		},
	},

	
	-- "gc" to comment visual regions/lines
	{ 'numToStr/Comment.nvim', opts = {} },

}


