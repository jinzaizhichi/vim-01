" vim: set ts=4 sw=4 tw=78 noet :
"======================================================================
"
" state.vim - state manager
"
" Created by skywind on 2022/12/24
" Last Modified: 2022/12/24 00:03:21
"
"======================================================================


"----------------------------------------------------------------------
" internal
"----------------------------------------------------------------------
let s:opts = {}
let s:path = []
let s:current = {}
let s:popup = 0
let s:vertical = 0
let s:position = ''
let s:screencx = 0
let s:screency = 0
let s:wincx = 0
let s:wincy = 0
let s:state = -1
let s:exit = 0
let s:prefix = ''


"----------------------------------------------------------------------
" translate key
"----------------------------------------------------------------------
let s:translate = { 
			\ "\<c-j>" : "\<down>",
			\ "\<c-k>" : "\<up>",
			\ "\<PageUp>" : "\<up>",
			\ "\<PageDown>" : "\<down>",
			\ "\<left>" : "\<left>",
			\ "\<right>" : "\<right>",
			\ "\<up>" : "\<up>",
			\ "\<down>" : "\<down>",
			\ "\<c-h>" : "\<left>",
			\ "\<c-l>" : "\<right>",
			\ }


"----------------------------------------------------------------------
" internal
"----------------------------------------------------------------------
function! s:config(what) abort
	return starter#config#get(s:opts, a:what)
endfunc


"----------------------------------------------------------------------
" init keymap and open window
"----------------------------------------------------------------------
function! starter#state#init(opts) abort
	let s:opts = deepcopy(a:opts)
	let s:popup = get(g:, 'quickui_starter_popup', 0)
	let s:vertical = s:config('vertical')
	let s:position = starter#config#position(s:config('position'))
	let s:screencx = &columns
	let s:screency = &lines
	let s:prefix = get(a:opts, 'prefix', '')
	if s:vertical == 0
		let s:wincx = s:screencx
		let s:wincy = s:config('min_height')
	else
		let s:wincx = s:config('min_width')
		let s:wincy = winheight(0)
	endif
	let s:state = 0
	let s:exit = 0
	let s:path = []
	call starter#display#init(s:opts)
	return 0
endfunc


"----------------------------------------------------------------------
" close window
"----------------------------------------------------------------------
function! starter#state#close() abort
	if s:state >= 0
		call starter#display#close()
	endif
	let s:state = -1
endfunc


"----------------------------------------------------------------------
" translate path elements from key to label
"----------------------------------------------------------------------
function! s:translate_path(path)
	let path = []
	if s:prefix != ''
		let t = starter#charname#get_key_label(s:prefix)
		let path += [t]
	endif
	for p in a:path
		let t = starter#charname#get_key_label(p)
		let path += [t]
	endfor
	return path
endfunc


"----------------------------------------------------------------------
" select: return key array
"----------------------------------------------------------------------
function! starter#state#select(keymap, path) abort
	let keymap = starter#config#visit(a:keymap, [])
	let ctx = starter#config#compile(keymap, s:opts)
	if len(ctx.items) == 0
		return []
	endif
	call starter#layout#init(ctx, s:opts, s:wincx, s:wincy)
	if ctx.pg_count <= 0
		return []
	endif
	let pg_count = ctx.pg_count
	let pg_size = ctx.pg_size
	let pg_index = 0
	call starter#layout#fill_pages(ctx, s:opts)
	if s:vertical == 0
		call starter#display#resize(-1, ctx.pg_height)
	endif
	let map = {}
	for key in ctx.keys
		let item = ctx.items[key]
		let code = item.code
		let map[code] = key
	endfor
	let path = s:translate_path(a:path)
	while 1
		if s:vertical == 0
			call starter#display#resize(-1, ctx.pg_height)
		endif
		call starter#display#update(ctx.pages[pg_index].content, path)
		noautocmd redraw
		try
			let code = getchar()
		catch /^Vim:Interrupt$/
			let code = "\<C-C>"
		endtry
		let ch = (type(code) == v:t_number)? nr2char(code) : code
		if ch == "\<ESC>" || ch == "\<c-c>"
			let s:exit = 1
			return []
		elseif has_key(s:translate, ch)
			let newch = s:translate[ch]
			if newch == "\<down>"
				let pg_index += 1
				let pg_index = (pg_index >= pg_count)? 0 : pg_index
			elseif newch == "\<up>"
				let pg_index -= 1
				let pg_index = (pg_index < 0)? (pg_index - 1) : pg_index
			elseif newch == "\<left>"
				return []
			endif
		elseif has_key(map, ch)
			let key = map[ch]
			let item = ctx.items[key]
			if item.child == 0
				return [key]
			endif
			let km = starter#config#visit(keymap, [key])
			let hr = starter#state#select(km, path + [key])
			if hr != []
				return [key] + hr
			endif
			if s:exit != 0
				return []
			endif
		endif
	endwhile
endfunc


"----------------------------------------------------------------------
" open keymap
"----------------------------------------------------------------------
function! starter#state#open(keymap, opts) abort
	let opts = deepcopy(a:opts)
	let hr = starter#state#init(opts)
	if hr != 0
		return []
	endif
	let key_array = starter#state#select(a:keymap, [])
	call starter#state#close()
	return key_array
endfunc


