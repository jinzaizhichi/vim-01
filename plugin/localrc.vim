"======================================================================
"
" localrc.vim - load local .lvimrc from where your file reside
"
" Created by skywind on 2023/08/18
" Last Modified: 2023/08/18 10:46:42
"
"======================================================================


"----------------------------------------------------------------------
" configuration
"----------------------------------------------------------------------

" file names to source
let g:localrc_name = get(g:, 'localrc_name', ['.lvimrc'])

" set to 1 to search from root to current directory
let g:localrc_reverse = get(g:, 'localrc_reverse', 0)

" set to 0 to disable sandbox
let g:localrc_sandbox = get(g:, 'localrc_sandbox', 1)

" set to 1 to local python script
let g:localrc_python = get(g:, 'localrc_python', 0)

" set to 0 to stop fire autocmd
let g:localrc_autocmd = get(g:, 'localrc_autocmd', 1)



"----------------------------------------------------------------------
" internal
"----------------------------------------------------------------------
let s:windows = has('win32') || has('win64') || has('win95') || has('win16')
let s:in_sourcing = 0
let s:source_uuid = 1


"----------------------------------------------------------------------
" buffer local object
"----------------------------------------------------------------------
function! s:object() abort
	if !exists('b:__localrc')
		let b:__localrc = {}
	endif
	return b:__localrc
endfunc


"----------------------------------------------------------------------
" path norm case
"----------------------------------------------------------------------
function! s:path_normcase(path) abort
	if s:windows == 0
		return (has('win32unix') == 0)? (a:path) : tolower(a:path)
	else
		return tolower(tr(a:path, '\', '/'))
	endif
endfunc


"----------------------------------------------------------------------
" returns 0 if two path equal to each other,
"----------------------------------------------------------------------
function! s:path_compare(path1, path2) abort
	let p1 = s:path_normcase(a:path1)
	let p2 = s:path_normcase(a:path2)
	return (p1 == p2)? 0 : 1
endfunc


"----------------------------------------------------------------------
" find script
"----------------------------------------------------------------------
function! s:find_script(filename) abort
	let path = fnamemodify(a:filename, ':p:h')
	let rcs = []
	while 1
		for name in g:localrc_name
			let p = fnamemodify(path . '/' . name, ':p')
			if s:windows
				let p = tr(p, '\', '/')
			endif
			if filereadable(p)
				call add(rcs, p)
			endif
		endfor
		let parent = fnamemodify(path, ':h')
		if s:path_compare(path, parent) == 0
			break
		endif
		let path = parent
	endwhile
	call reverse(rcs)
	if get(g:, 'localrc_reverse', 0)
		call reverse(rcs)
	endif
	if get(g:, 'localrc_count', -1) > 0
		let rcs = slice(rcs, 0, g:localrc_count)
	endif
	return rcs
endfunc


"----------------------------------------------------------------------
" source file
"----------------------------------------------------------------------
function! s:source_rc(rcname, sandbox) abort
	if s:in_sourcing != 0
		return -1
	endif

	if a:rcname =~ '\.lua$'
		if has('nvim')
			let cmd = 'luafile ' . fnameescape(a:rcname)
		elseif has('lua')
			let cmd = 'luafile ' . fnameescape(a:rcname)
		else
			return -3
		endif
	elseif a:rcname =~ '\.py$' && g:localrc_python
		if has('python3')
			let cmd = 'py3file ' . fnameescape(a:rcname)
		elseif has('pythonx')
			let cmd = 'pyxfile ' . fnameescape(a:rcname)
		elseif has('python2')
			let cmd = 'pyfile ' . fnameescape(a:rcname)
		else
			return -4
		endif
	else
		let cmd = 'source ' . fnameescape(a:rcname)
	endif

	if a:sandbox
		let cmd = 'sandbox ' . cmd
	endif

	let s:in_sourcing = 1
	let done = 0

	try
		exec cmd
		let done = 1
	catch
		let msg = v:throwpoint
		let p1 = stridx(msg, 'source_rc[')
		if p1 > 0
			let p2 = stridx(msg, ']..', p1)
			if p2 > 0
				let msg = strpart(msg, p2 + 3)
			endif
		endif
		redraw
		echohl ErrorMsg
		echom printf('%s: %s', msg, v:exception)
		echohl None
	endtry

	let s:in_sourcing = 0

	if done == 0
		return -5
	endif

	return 0
endfunc


" call s:source_rc('c:/share/vim/.lvimrc')

"----------------------------------------------------------------------
" match pattern
"----------------------------------------------------------------------
function! s:pattern_match(patterns, str) abort
	for pattern in a:patterns
		try
			if match(a:str, pattern) >= 0
				return 1
			endif
		catch
			echohl ErrorMsg
			echom v:exception
			echohl None
		endtry
	endfor
	return 0
endfunc


"----------------------------------------------------------------------
" local localrc for current source
"----------------------------------------------------------------------
function! s:load_localrc() abort
	let bid = bufnr('%')
	let bname = fnamemodify(bufname(bid), ':p')
	let rcs = s:find_script(bname)
	if s:in_sourcing != 0
		return -1
	endif
	for rcname in rcs
		let rcname = fnamemodify(rcname, ':p')
		let sandbox = g:localrc_sandbox
		if exists('g:localrc_blacklist')
			if s:pattern_match(g:localrc_blacklist, rcname)
				continue
			endif
		endif
		if exists('g:localrc_whitelist')
			if !s:pattern_match(g:localrc_whitelist, rcname)
				continue
			endif
		endif
		if s:path_compare(rcname, bname) == 0
			continue
		endif
		call s:source_rc(rcname, sandbox)
	endfor
	return 0
endfunc


"----------------------------------------------------------------------
" autoload
"----------------------------------------------------------------------
function! s:load_check() abort
	if get(g:, 'localrc_enable', 1) == 0
		return 0
	endif
	let uuid = get(b:, '__localrc_uuid', 0)
	if uuid == s:source_uuid
		return 0
	endif
	call s:load_localrc()
	let b:__localrc_uuid = s:source_uuid
	return 1
endfunc



"----------------------------------------------------------------------
" augroup
"----------------------------------------------------------------------
augroup LocalRcAutocmdGroup
	au!
augroup END



