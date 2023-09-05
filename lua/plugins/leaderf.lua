local utils = require('core.utils')
local custom = require('config.custom')
local package_enabled = utils.package_enabled
local inc = utils.include_script
local has_py3 = (vim.fn.has('python3') ~= 0)

return {
	{
		'Yggdroot/LeaderF',
		cmd = 'Leaderf', -- haha
		-- cmd = 'Leaderf',
		enabled = has_py3,
		-- keys = {
		-- 	{'<c-x><c-x>', '<c-\\><c-o>:Leaderf snippet<cr>', mode = 'i', 'leaderf-snippet'},
		-- },
		config = function () 
			vim.g.lf_disable_normal_map = 1
			inc('site/bundle/leaderf.vim')
		end,
	},

	{ 
		'tamago324/LeaderF-filer', 
		dependencies = {'Yggdroot/LeaderF'},
		-- cmd = 'Leaderf',
		enabled = has_py3,
	},
	{ 
		'voldikss/LeaderF-emoji', 
		dependencies = {'Yggdroot/LeaderF'},
		-- cmd = 'Leaderf',
		enabled = has_py3,
	},
}


