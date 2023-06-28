"======================================================================
"
" extension.vim - 
"
" Created by skywind on 2023/06/28
" Last Modified: 2023/06/28 16:02:42
"
"======================================================================


"----------------------------------------------------------------------
" 
"----------------------------------------------------------------------
function! module#extension#help(name)
	let path = asclib#path#runtime('site/doc/' . a:name . '.txt')
	if !filereadable(path)
		call asclib#core#errmsg('Not find file ' . path)
	else
		" let 
	endif
endfunc


"----------------------------------------------------------------------
" 
"----------------------------------------------------------------------
function! module#extension#help_comp(ArgLead, CmdLine, CursorPos)
endfunc


