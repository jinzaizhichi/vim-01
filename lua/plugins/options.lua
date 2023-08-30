local utils = require('core.utils')
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

}


