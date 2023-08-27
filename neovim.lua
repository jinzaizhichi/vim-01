--=====================================================================
--
-- neovim.lua - 
--
-- Created by skywind on 2023/08/27
-- Last Modified: 2023/08/27 03:19:59
--
--=====================================================================
local scriptpath = debug.getinfo(1, 'S').source:sub(2)
local scripthome = vim.fn.fnamemodify(scriptpath, ':h')

vim.opt.rtp:prepend(scripthome)
package.path = package.path .. ';' .. scripthome .. '/lua/?.lua'


-----------------------------------------------------------------------
-- ensure lazy
-----------------------------------------------------------------------
function lazy_ensure_install()
	local lazypath = vim.fn.expand('~/.vim/lazy.nvim')
	local refresh = false
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system {
			'git',
			'clone',
			'--filter=blob:none',
			'https://github.com/folke/lazy.nvim.git',
			'--branch=stable', -- latest stable release
			lazypath,
		}
		refresh = true
	end
	vim.opt.rtp:prepend(lazypath)
	return refresh
end

local refresh_install = lazy_ensure_install()


-----------------------------------------------------------------------
-- lazy options
-----------------------------------------------------------------------
local opts = {
	performance = {
		rtp = {
			reset = false
		}
	}
}


-----------------------------------------------------------------------
-- lazy setup
-----------------------------------------------------------------------
require('lazy').setup("plugins", opts)


-----------------------------------------------------------------------
-- options
-----------------------------------------------------------------------


