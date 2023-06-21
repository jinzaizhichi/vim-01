"======================================================================
"
" mockcmd.vim - 
"
" Created by skywind on 2023/06/22
" Last Modified: 2023/06/22 00:55:12
"
"======================================================================

function! s:mockcmd(cmdname, bang, line1, line2, args, init)
	if exists(':' . a:cmdname) == 2
		exec 'delcommand ' . a:cmdname
	endif
	if type(a:init) == type('')
		exec a:init
	elseif type(a:init) == type([])
		exec join(a:init, "\n")
	endif
	let t = printf("%d,%d", a:line1, a:line2)
	let t = printf("%s%s%s", (a:line1 == a:line2)? '' : t, a:cmdname, a:bang)
	exec t . ' ' . a:args
endfunc


