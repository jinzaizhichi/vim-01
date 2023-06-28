"======================================================================
"
" extension.vim - 
"
" Created by skywind on 2023/06/28
" Last Modified: 2023/06/28 16:02:42
"
"======================================================================


"----------------------------------------------------------------------
" display help
"----------------------------------------------------------------------
function! module#extension#help(name)
	let path = asclib#path#runtime('site/doc/' . a:name . '.txt')
	if !filereadable(path)
		call asclib#common#errmsg('E149: Sorry, no help for ' . a:name)
	else
		call asclib#utils#display(path, 'auto')
	endif
endfunc


"----------------------------------------------------------------------
" list keys
"----------------------------------------------------------------------
function! module#extension#help_list()
	let pattern = asclib#path#runtime('site/doc/*.txt')
	let keys = []
	for name in split(asclib#path#glob(pattern), "\n")
		let nm = fnamemodify(name, ':t:r')
		let keys += [nm]
	endfor
	return keys
endfunc


"----------------------------------------------------------------------
" help complete
"----------------------------------------------------------------------
function! module#extension#help_complete(ArgLead, CmdLine, CursorPos)
	let keys = module#extension#help_list()
	return asclib#common#complete(a:ArgLead, a:CmdLine, a:CursorPos, keys)
endfunc


