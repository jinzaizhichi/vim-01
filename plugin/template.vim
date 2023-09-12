"======================================================================
"
" template.vim - 
"
" Created by skywind on 2023/09/12
" Last Modified: 2023/09/12 16:53:27
"
"======================================================================

" template path in every runtime path
let g:template_name = get(g:, 'template_name', 'template')

" absolute path list
let g:template_path = get(g:, 'template_path', ['~/.vim/template'])


"----------------------------------------------------------------------
" internal
"----------------------------------------------------------------------
let s:scripthome = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')


"----------------------------------------------------------------------
" list template directories
"----------------------------------------------------------------------
function! s:template_dirs() abort
	let dirlist = []
	let root = s:scripthome .. '/site/template'
	if isdirectory(root)
		call add(dirlist, tr(root, '\', '/'))
	endif
	for rtp in split(&rtp, ',')
		let t = rtp .. '/' .. g:template_name
		if isdirectory(t)
			call add(dirlist, tr(t, '\', '/'))
		endif
	endfor
	if type(g:template_path) == type('')
		let path = split(g:template_path, ',')
	elseif type(g:template_path) == type([])
		let path = g:template_path
	else
		let path = []
	endif
	for t in path
		if isdirectory(t)
			call add(dirlist, tr(t, '\', '/'))
		endif
	endfor
	return dirlist
endfunc


"----------------------------------------------------------------------
" list available templates
"----------------------------------------------------------------------
function! s:template_list(filetype) abort
	let dirs = s:template_dirs()
	let templates = {}
	for base in dirs
		let path = base
		if a:filetype != ''
			let path = base .. '/' .. (a:filetype)
		endif
		if !isdirectory(path)
			continue
		endif
		let filelist = globpath(path, '*.txt', 1, 1)
		for name in filelist
			let main = fnamemodify(name, ':t:r')
			let templates[main] = name
		endfor
	endfor
	return templates
endfunc


"----------------------------------------------------------------------
" expand text
"----------------------------------------------------------------------
function! s:text_expand(text, mark_open, mark_close, environ) abort
	let mark_open = a:mark_open
	let mark_close = a:mark_close
	let size_open = strlen(mark_open)
	let size_close = strlen(mark_close)
	let text = a:text
	while 1
		let p1 = stridx(text, mark_open)
		if p1 < 0
			break
		endif
		let p2 = stridx(text, mark_close, p1 + size_open)
		if p2 < 0
			break
		endif
		let before = strpart(text, 0, p1)
		let body = strpart(text, p1 + size_open, p2 - p1 - size_open)
		let after = strpart(text, p2 + size_close)
		let envname = matchstr(body, '^%\zs.*\ze%$')
		let replace = '<ERROR>'
		if envname != ''
			if has_key(a:environ, envname)
				let replace = a:environ[envname]
			endif
		endif
		try
			let replace = printf('%s', eval(body))
		catch
			let replace = v:exception
		endtry
		let text = before .. replace .. after
	endwhile
	return text
endfunc


"----------------------------------------------------------------------
" load template
"----------------------------------------------------------------------
function! s:template_load(filetype, name) abort
	let templates = s:template(a:filetype)
	if !has_key(templates, a:name)
		return v:null
	endif
	let textlist = []
	let content = readfile(templates[a:name])
	let environ = s:create_environ()
	for text in content
		let p1 = stridx(text, '`')
		if p1 >= 0
			let text = s:text_expand(text, '`', '`', environ)
		endif
		call add(content, text)
	endfor
	return textlist
endfunc



