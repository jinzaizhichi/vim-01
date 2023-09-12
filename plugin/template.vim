"======================================================================
"
" template.vim - 
"
" Created by skywind on 2023/09/12
" Last Modified: 2023/09/12 19:08
"
"======================================================================


" template path in every runtime path
let g:template_name = get(g:, 'template_name', 'template')

" absolute path list
let g:template_path = get(g:, 'template_path', ['~/.vim/template'])

" absolute path for :TemplateEdit
let g:template_edit = get(g:, 'template_path', '~/.vim/template')

" set to 1 to insert above cursor when using :Template! {name}
let g:template_above = get(g:, 'template_above', 0)


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
	let loc_list = []
	if type(g:template_path) == type('')
		let loc_list = split(g:template_path, ',')
	elseif type(g:template_path) == type([])
		let loc_list = g:template_path
	elseif type(g:template_path) == type({})
		let loc_list = keys(g:template_path)
	endif
	if exists('b:template_path')
		if type(b:template_path) == type('')
			call extend(loc_list, split(b:template_path, ','))
		elseif type(b:template_path) == type([])
			call extend(loc_list, b:template_path)
		elseif type(b:template_path) == type({})
			call extend(loc_list, keys(b:template_path))
		endif
	endif
	for t in loc_list
		let t = expand(t)
		if t != '' && isdirectory(t)
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
function! s:text_expand(text, mark_open, mark_close, macros) abort
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
		let name = matchstr(body, '^%\zs.*\ze%$')
		let replace = '<ERROR>'
		if name != '' && has_key(a:macros, name)
			let replace = a:macros[name]
		else
			try
				let replace = printf('%s', eval(body))
			catch
				let replace = v:exception
			endtry
		endif
		let text = before .. replace .. after
	endwhile
	return text
endfunc


"----------------------------------------------------------------------
" create environ
"----------------------------------------------------------------------
function! s:expand_macros()
	let macros = {}
	let macros['FILEPATH'] = expand("%:p")
	let macros['FILENAME'] = expand("%:t")
	let macros['FILEDIR'] = expand("%:p:h")
	let macros['FILENOEXT'] = expand("%:t:r")
	let macros['PATHNOEXT'] = expand("%:p:r")
	let macros['FILEEXT'] = "." . expand("%:e")
	let macros['FILETYPE'] = (&filetype)
	let macros['CWD'] = getcwd()
	let macros['RELDIR'] = expand("%:h:.")
	let macros['RELNAME'] = expand("%:p:.")
	let macros['CWORD'] = expand("<cword>")
	let macros['CFILE'] = expand("<cfile>")
	let macros['CLINE'] = line('.')
	let macros['VERSION'] = ''.v:version
	let macros['SVRNAME'] = v:servername
	let macros['COLUMNS'] = ''.&columns
	let macros['LINES'] = ''.&lines
	let macros['GUI'] = has('gui_running')? 1 : 0
	let macros['ROOT'] = asyncrun#get_root('%')
	let macros['HOME'] = expand(split(&rtp, ',')[0])
	let macros['PRONAME'] = fnamemodify(macros['ROOT'], ':t')
	let macros['DIRNAME'] = fnamemodify(macros['CWD'], ':t')
	let macros['<cwd>'] = macros['CWD']
	let macros['<root>'] = macros['ROOT']
	let macros['YEAR'] = strftime('%Y')
	let macros['MONTH'] = strftime('%m')
	let macros['DAY'] = strftime('%d')
	let macros['TIME'] = strftime('%H:M')
	let macros['DATE'] = strftime('%Y-%m-%d')
	let macros['USER'] = ''
	if expand("%:e") == ''
		let macros['FILEEXT'] = ''
	endif
	let t = expand('~')
	if t != ''
		let macros['USER'] = fnamemodify(t, ':t')
	endif
	return macros
endfunc


"----------------------------------------------------------------------
" load template
"----------------------------------------------------------------------
function! s:template_load(filetype, name) abort
	let templates = s:template_list(a:filetype)
	if !has_key(templates, a:name)
		return 0
	endif
	let textlist = []
	let content = readfile(templates[a:name])
	let macros = s:expand_macros()
	for text in content
		let p1 = stridx(text, '`')
		if p1 >= 0
			let text = s:text_expand(text, '`', '`', macros)
		endif
		call add(textlist, text)
	endfor
	return textlist
endfunc


"----------------------------------------------------------------------
" :Template[!] {name} [, filetype]
"----------------------------------------------------------------------
function! s:Template(bang, name)
	let part = split(a:name, '/', 1)
	if len(part) == 1
		let name = part[0]
		let ft = &ft
	else
		let name = part[1]
		let ft = part[0]
	endif
	let content = s:template_load(ft, name)
	if type(content) == type(0)
		echohl ErrorMsg
		echo 'ERROR: template not find: ' .. a:name
		echohl None
		return 0
	endif
	if a:bang == 0
		let bid = bufnr('%')
		silent call deletebufline(bid, 1, '$')
		silent call setbufline(bid, 1, content)
	else
		if g:template_above == 0
			call append('.', content)
		else
			call append(line('.') - 1, content)
		endif
	endif
	return 0
endfunc


"----------------------------------------------------------------------
" command complete
"----------------------------------------------------------------------
function! s:complete(ArgLead, CmdLine, CursorPos)
	let candidate = []
	if stridx(a:ArgLead, '/') < 0
		let templates = s:template_list(&ft)
		let names = keys(templates)
	else
		let part = split(a:ArgLead, '/', 1)
		let ft = part[0]
		let templates = s:template_list(ft)
		let names = []
		" echo type(templates)
		for temp in keys(templates)
			call add(names, ft . '/' . temp)
		endfor
	endif
	call sort(names)
	for name in names
		if stridx(name, a:ArgLead) == 0
			let candidate += [name]
		endif
	endfor
	return candidate
endfunc


"----------------------------------------------------------------------
" command defintion
"----------------------------------------------------------------------
command! -bang -nargs=1 -range=0 -complete=customlist,s:complete Template
			\ call s:Template(<bang>0, <q-args>)



