"======================================================================
"
" git.vim - 
"
" Created by skywind on 2023/08/09
" Last Modified: 2023/08/09 16:04:27
"
"======================================================================


"----------------------------------------------------------------------
" get branch info
"----------------------------------------------------------------------
function! asclib#git#info_branch(where)
	let root = asclib#vcs#croot(a:where, 'git')
	if root == ''
		return ''
	endif
	let hr = asclib#vcs#git('branch', root)
	if g:asclib#core#shell_error == 0
		let hr = asclib#string#strip(hr)
		let name = matchstr(hr, '^\*\s*\zs\S\+\ze\s*$')
		return asclib#string#strip(name)
	endif
	return ''
endfunc


"----------------------------------------------------------------------
" get remote url
"----------------------------------------------------------------------
function! asclib#git#info_remote(where, name)
	let root = asclib#vcs#croot(a:where, 'git')
	if root == ''
		return ''
	endif
	let hr = asclib#vcs#git('remote get-url ' . a:name, root)
	return (g:asclib#core#shell_error == 0)? asclib#string#strip(hr) : ''
endfunc


