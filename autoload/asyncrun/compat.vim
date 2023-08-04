"======================================================================
"
" compat.vim - 
"
" Created by skywind on 2023/08/03
" Last Modified: 2023/08/03 23:45:25
"
"======================================================================


"----------------------------------------------------------------------
" internal 
"----------------------------------------------------------------------
let s:windows = has('win32') || has('win95') || has('win64') || has('win16')
let s:python = -1


"----------------------------------------------------------------------
" glob files
"----------------------------------------------------------------------
function! asyncrun#compat#glob( ... )
	let l:nosuf = (a:0 > 1 && a:2)
	let l:list = (a:0 > 2 && a:3)
	if l:nosuf
		let l:save_wildignore = &wildignore
		set wildignore=
	endif
	try
		let l:result = call('glob', [a:1])
		return (l:list ? split(l:result, '\n') : l:result)
	finally
		if exists('l:save_wildignore')
			let &wildignore = l:save_wildignore
		endif
	endtry
endfunc


"----------------------------------------------------------------------
" list files
"----------------------------------------------------------------------
function! asyncrun#compat#list(path, ...)
	let nosuf = (a:0 > 0)? (a:1) : 0
	if !isdirectory(a:path)
		return []
	endif
	let path = a:path . '/*'
	let part = asyncrun#compat#glob(path, nosuf)
	let candidate = []
	for n in split(part, "\n")
		let f = fnamemodify(n, ':t')
		if !empty(f)
			call add(candidate, f)
		endif
	endfor
	return candidate
endfunc


"----------------------------------------------------------------------
" check python
"----------------------------------------------------------------------
function! asyncrun#compat#check_python()
	if s:python >= 0
		return s:python
	endif
	if !has('python3')
		if !has('python2')
			if !has('python')
				let s:python = 0
				return 0
			endif
		endif
	endif
	let s:python = 0
	try
		silent! pyx import os as __os
		silent! pyx import vim as __vim
		silent! pyx __vim.execute('let avail = 1')
		silent! let s:python = pyxeval('1')
	catch
	endtry
	return s:python
endfunc


"----------------------------------------------------------------------
" list fts
"----------------------------------------------------------------------
function! asyncrun#compat#list_fts()
	let output = []
	for name in asyncrun#compat#list($VIMRUNTIME . '/syntax', 1)
		let extname = fnamemodify(name, ':e')
		" echo name
		if extname == 'vim'
			call add(output, fnamemodify(name, ':t:r'))
		endif
	endfor
	return output
endfunc


"----------------------------------------------------------------------
" list environment names
"----------------------------------------------------------------------
function! asyncrun#compat#list_envname()
	if has('python3') == 0
		if has('python2') == 0
			return []
		endif
	endif
	let result = []
	try
		silent! pyx import os as __os
		silent! let result = pyxeval('[name for name in __os.environ]')
	catch
	endtry
	return result
endfunc


"----------------------------------------------------------------------
" 
"----------------------------------------------------------------------
function! asyncrun#compat#list_path()
	return split($PATH, s:windows? ';' : ':')
endfunc


"----------------------------------------------------------------------
" 
"----------------------------------------------------------------------
function! asyncrun#compat#list_exe_py()
pyx << PYEOF
if 1:
	import sys, os
	_sep = sys.platform[:3] == 'win' and ';' or ':'
	_search = os.environ.get('PATH', '').split(_sep)
	_exename = {}
	for _dirname in _search:
		if not os.path.exists(_dirname):
			continue
		for fn in os.listdir(_dirname):
			if _sep == ':':
				_exename[fn] = 1
			else:
				_fn, _ext = os.path.splitext(os.path.split(fn)[-1])
				if _ext in ('.exe', '.cmd', '.bat'):
					_exename[_fn] = 1
	_output = [n for n in _exename]
	_output.sort()
PYEOF
	return pyxeval('_output')
endfunc


"----------------------------------------------------------------------
" 
"----------------------------------------------------------------------
function! asyncrun#compat#list_executable()
	let output = {}
	let check = {'exe': 1, 'cmd':1, 'bat':1}
	if asyncrun#compat#check_python()
		" return asyncrun#compat#list_exe_py()
	endif
	for dirname in asyncrun#compat#list_path()
		if !isdirectory(dirname)
			continue
		endif
		if s:windows != 0
			for ext in ['exe', 'cmd', 'bat']
				let part = asyncrun#compat#glob(dirname . '/*.' . ext, 1)
				for exename in split(part, "\n")
					let fn = fnamemodify(exename, ':t:r')
					let output[fn] = 1
				endfor
			endfor
		else
			let part = asyncrun#compat#glob(dirname . '/*', 1)
			for exename in split(part, "\n")
				if executable(exename)
					let fn = fnamemodify(exename, ':t')
					let output[fn] = 1
				endif
			endfor
		endif
	endfor
	return keys(output)
endfunc



" echo len(asyncrun#compat#list_exe_py())
echo len(asyncrun#compat#list_executable())


