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
	local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
	-- local lazypath = vim.fn.expand('~/.vim/lazy.nvim')
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
-- local config
-----------------------------------------------------------------------
local filelist = vim.fn.glob(scripthome .. '/lua/config/*.lua', 0)

if vim.fn.filereadable(scripthome .. '/lua/config/init.lua') ~= 0 then
	require 'config.init'
end

if filelist ~= nil then
	local names = vim.fn.split(filelist, '\n')
	table.sort(names)
	for _, fn in ipairs(names) do
		local name = vim.fn.fnamemodify(fn, ':t:r')
		if name ~= 'init' then
			local path = 'config.' .. name
			package.loaded[path] = nil
			require(path)
			-- print('->', name)
		end
	end
end


-----------------------------------------------------------------------
-- options
-----------------------------------------------------------------------


