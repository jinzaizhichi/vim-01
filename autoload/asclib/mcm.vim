"======================================================================
"
" mcm.vim - completion
"
" Created by skywind on 2023/08/03
" Last Modified: 2023/08/03 20:51:46
"
"======================================================================


"----------------------------------------------------------------------
" context before cursor
"----------------------------------------------------------------------
function! asclib#mcm#context() abort
	return strpart(getline('.'), 0, col('.') - 1)
endfunc


"----------------------------------------------------------------------
" check tailing space
"----------------------------------------------------------------------
function! asclib#mcm#check_space(context) abort
	return (a:context == '' || a:context =~ '\s\+$')? 1 : 0
endfunc


"----------------------------------------------------------------------
" filter list
"----------------------------------------------------------------------
function! asclib#mcm#match_list(list, prefix) abort
	let output = []
	let prefix = a:prefix
	for n in a:list
		if stridx(n, prefix) == 0
			call add(output, n)
		endif
	endfor
	return output
endfunc


