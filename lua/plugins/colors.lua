return {
	{
		"sainnhe/sonokai",
		config = function()
			-- vim.cmd.colorscheme 'sonokai'
		end,
	},

	{
		'sainnhe/everforest',
		config = function()
			vim.cmd.colorscheme 'everforest'
		end
	},

	{
		'loctvl842/monokai-pro.nvim',
		config = function()
			require("monokai-pro").setup()
			-- vim.cmd.colorscheme 'monokai-pro'
		end,
	},
}


