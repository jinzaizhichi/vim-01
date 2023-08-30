local utils = require('core.utils')
local package_enabled = utils.package_enabled

return {
	{
		'skywind3000/vim-gutentags',
		config = function()
			local modules = {}
			if vim.fn.executable('ctags') then
				table.insert(modules, 'ctags')
			end
			if vim.fn.executable('gtags-cscope') then
				table.insert(modules, 'gtags_cscope')
			end
			vim.g.gutentags_modules = modules
		end,
	},

	{
	},
}


