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
let s:keymap = {}
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
let s:opened = 0
let s:prefix = ''


"----------------------------------------------------------------------
" translate key
"----------------------------------------------------------------------
let s:translate = { 
			\ "\<c-j>" : "\<down>",
			\ "\<c-k>" : "\<up>",
			\ "\<PageUp>" : "\<up>",
			\ "\<PageDown>" : "\<down>",
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
function! starter#state#init(keymap, opts) abort
	let s:keymap = a:keymap
	let s:opts = deepcopy(a:opts)
	let s:popup = get(g:, 'quickui_starter_popup', 0)
	let s:vertical = s:config('vertical')
	let s:position = starter#config#position(s:config('position'))
	let s:screencx = &columns
	let s:screency = &lines
	if s:vertical == 0
		let s:wincx = s:screencx
		let s:wincy = s:config('min_height')
	else
		let s:wincx = s:config('min_width')
		let s:wincy = winheight(0)
	endif
	let s:state = 0
	let s:opened = 0
	let s:path = []
	call starter#display#init(s:opts)
endfunc


"----------------------------------------------------------------------
" close window
"----------------------------------------------------------------------
function! starter#state#close() abort
	let s:state = -1
	if s:state >= 0
		call starter#display#close()
	endif
endfunc


"----------------------------------------------------------------------
" select: return selected key, '' for no select, "\<esc>" for quit
"----------------------------------------------------------------------
function! starter#state#select(keymap, path) abort
	let keymap = a:keymap
	let ctx = starter#config#compile(keymap, s:opts)
	if len(ctx.items) == 0
		return ''
	endif
	call starter#layout#init(ctx, s:opts, s:wincx, s:wincy)
	if ctx.pg_count <= 0
		return ''
	endif
	let pg_count = ctx.pg_count
	let pg_size = ctx.pg_size
	let pg_index = 0
	call starter#layout#fill_pages(ctx, s:opts)
	if s:vertical == 0
		call starter#display#resize(-1, ctx.pg_height)
	endif
	let s:map = {}
	for key in ctx.keys
		let item = ctx.items[key]
		let code = item.code
		let s:map[code] = key
	endfor
	while 1
		call starter#display#update(ctx.pages[pg_index].content)
		noautocmd redraw
		try
			let code = getchar()
		catch /^Vim:Interrupt$/
			let code = "\<C-C>"
		endtry
		let ch = (type(code) == v:t_number)? nr2char(code) : code
		if ch == "\<ESC>" || ch == "\<c-c>"
			return "\<esc>"
		elseif has_key(s:translate, ch)
			let newch = s:translate[ch]
			if newch == "\<down>"
				let pg_index += 1
				let pg_index = (pg_index >= pg_count)? 0 : pg_index
			elseif newch == "\<up>"
				let pg_index -= 1
				let pg_index = (pg_index < 0)? (pg_index - 1) : pg_index
			endif
		elseif has_key(s:map, ch)
			let key = s:map[ch]
			let item = ctx.items[key]
			return key
		endif
	endwhile
endfunc


