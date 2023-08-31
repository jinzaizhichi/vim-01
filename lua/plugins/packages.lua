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

	'jamessan/vim-gnupg',

	-- 'kana/vim-textobj-user',
	{ 'kana/vim-textobj-syntax', dependencies = {'kana/vim-textobj-user'} },
	{ 'sgur/vim-textobj-parameter', dependencies = {'kana/vim-textobj-user'} },
	{ 'bps/vim-textobj-python', dependencies = {'kana/vim-textobj-user'} },
	{ 'jceb/vim-textobj-uri', dependencies = {'kana/vim-textobj-user'} },

	{
		'nvim-orgmode/orgmode',
		config = function()
			utils.defer_init(10, function()
					require('orgmode').setup_ts_grammar()
					require('orgmode').setup {
					}
				end)
		end
	},

	{
		'kshenoy/vim-signature',
	},

	{
		'mhinz/vim-signify',
	},
}


