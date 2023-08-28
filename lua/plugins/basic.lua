local utils = require('core.utils')
local inc = utils.include_script

return {
	{'tpope/vim-fugitive', config = function() inc('site/bundle/git.vim') end },
	'tpope/vim-rhubarb',
	'tpope/vim-unimpaired',
	{'justinmk/vim-dirvish', config = function() inc('site/bundle/dirvish.vim') end },
	{'bootleq/vim-cycle', config = function() inc('site/bundle/dirvish.vim') end },
	
	't9md/vim-choosewin',
	'tommcdo/vim-exchange',
	'tommcdo/vim-lion',
}


