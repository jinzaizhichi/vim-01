local scriptpath = debug.getinfo(1, 'S').source:sub(2)
local scripthome = vim.fn.fnamemodify(scriptpath, ':h')

vim.opt.rtp:prepend(scripthome)

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



