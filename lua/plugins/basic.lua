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
		config = function()
			vim.cmd [[
				nnoremap gb= :Tabularize /=<CR>
				vnoremap gb= :Tabularize /=<CR>
				nnoremap gb/ :Tabularize /\/\//l4c1<CR>
				vnoremap gb/ :Tabularize /\/\//l4c1<CR>
				nnoremap gb* :Tabularize /\/\*/l4c1<cr>
				vnoremap gb* :Tabularize /\/\*/l4c1<cr>
				nnoremap gb, :Tabularize /,/r0l1<CR>
				vnoremap gb, :Tabularize /,/r0l1<CR>
				nnoremap gbl :Tabularize /\|<cr>
				vnoremap gbl :Tabularize /\|<cr>
				nnoremap gbc :Tabularize /#/l4c1<cr>
				vnoremap gbc :Tabularize /#/l4c1<cr>
				nnoremap gb<bar> :Tabularize /\|<cr>
				vnoremap gb<bar> :Tabularize /\|<cr>
				nnoremap gbr :Tabularize /\|/r0<cr>
				vnoremap gbr :Tabularize /\|/r0<cr>
			]]
		end,
	},

	{
		'justinmk/vim-sneak',
		config = function()
			vim.cmd [[
				nmap gz <Plug>Sneak_s
				nmap gZ <Plug>Sneak_S
				vmap gz <Plug>Sneak_s
				vmap gZ <Plug>Sneak_S
				xmap gz <Plug>Sneak_s
				xmap gZ <Plug>Sneak_S
			]]
		end,
	},

	
	-- "gc" to comment visual regions/lines
	{ 'numToStr/Comment.nvim', opts = {} },

}


