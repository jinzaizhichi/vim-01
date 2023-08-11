"======================================================================
"
" test_gscope.vim - 
"
" Created by skywind on 2023/08/11
" Last Modified: 2023/08/11 11:13:54
"
"======================================================================

function! GscopeRun(exename, root, database, pattern, word)
	if !executable(a:exename)
		return ''
	endif
	let $GTAGSROOT = a:root
	let $GTAGSDBPATH = a:database
	let dbname = a:database . '\GTAGS'
	if has('win32') || has('win64') || has('win95') || has('win16')
		let cmd = 'cd /d ' . shellescape(a:root) . ' && ' . a:exename
		let win = 1
	else
		let cmd = 'cd ' . shellescape(a:root) . ' && ' . a:exename
		let win = 0
	endif
	let cmd = cmd . ' -d '
	let cmd = cmd . ' -F ' . shellescape(dbname)
	let cmd = cmd . ' -L -' . (a:pattern) . ' ' . shellescape(a:word)
	let content = system(cmd)
	let output = []
	for text in split(content, "\n")
		let text = substitute(text, '^\s*\(.\{-}\)\s*$', '\1', '')
		if text == ''
			continue
		endif
		let p1 = stridx(text, ' ')
		if p1 < 0
			continue
		endif
		let fn = strpart(text, 0, p1)
		let p2 = stridx(text, ' ', p1 + 1)
		if p2 < 0
			continue
		endif
		let fw = strpart(text, p1 + 1, p2 - p1 - 1)
		let p3 = stridx(text, ' ', p2 + 1)
		if p3 < 0
			continue
		endif
		let fl = strpart(text, p2 + 1, p3 - p2 - 1)
		let ft = strpart(text, p3 + 1)
		let nn = a:root . '/' . fn
		if win != 0
			let nn = tr(nn, "/", '\')
		endif
		let tt = printf('%s(%d): <<%s>> %s', nn, fl, fw, ft)
		call add(output, tt)
	endfor
	return output
endfunc


let exename = 'gtags-cscope'
let root = 'E:\Code\ping\bbnet'
let database = 'E:\Local\Cache\tags\E--Code-ping-bbnet'

echo GscopeRun(exename, root, database, 0, 'ProtocolFlush')

