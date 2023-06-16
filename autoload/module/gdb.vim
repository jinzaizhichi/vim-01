"======================================================================
"
" gdb.vim - 
"
" Created by skywind on 2023/06/16
" Last Modified: 2023/06/16 22:21:16
"
"======================================================================

function! module#gdb#start(name) abort
	packadd termdebug
	exec 'Termdebug ' . ((a:name == '')? '' : fnameescape(a:name))
endfunc

function! module#gdb#send(command) abort
	return TermDebugSendCommand(a:command)
endfunc

