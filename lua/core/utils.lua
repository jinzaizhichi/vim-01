--=====================================================================
--
-- utils.lua - 
--
-- Created by skywind on 2023/08/28
-- Last Modified: 2023/08/28 11:43:53
--
--=====================================================================


-----------------------------------------------------------------------
-- module initialize
-----------------------------------------------------------------------
local modname = ...
if modname ~= nil then
	local MM = {}
	setmetatable(MM, {__index = _G})
	package.loaded[modname] = MM
	if _ENV ~= nil then _ENV = MM else setfenv(1, MM) end
end


-----------------------------------------------------------------------
-- internal
-----------------------------------------------------------------------
local ascmini = require('core.ascmini')
local rtpbase = ''


-----------------------------------------------------------------------
-- runtime path
-----------------------------------------------------------------------
function runtime(fname)
	if rtpbase == '' then
		rtpbase = vim.call('asclib#path#runtime', '')
	end
	return os.path.normpath(os.path.join(rtpbase, fname))
end


-----------------------------------------------------------------------
-- load vim script
-----------------------------------------------------------------------
function load_vim_script(fname)
	local escaped = vim.fn.fnameescape(fname)
	if vim.fn.has('nvim') ~= 0 then
		vim.cmd('source ' .. escaped)
	else
		vim.command('source ' .. escaped)
	end
end


-----------------------------------------------------------------------
-- load runtime script
-----------------------------------------------------------------------
function include_script(fname)
	local path = vim.call('asclib#path#runtime', fname)
	return load_vim_script(path)
end


-----------------------------------------------------------------------
-- current project root
-----------------------------------------------------------------------
function current_root()
	return vim.call('asclib#path#current_root')
end


-----------------------------------------------------------------------
-- run function in directory
-----------------------------------------------------------------------
function with_directory(path, func)
	local old = vim.call('getcwd')
	vim.call('asclib#path#chdir_noautocmd', path)
	func()
	vim.call('asclib#path#chdir_noautocmd', old)
end


-- local ascmini = require('core.ascmini')



