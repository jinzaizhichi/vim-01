"======================================================================
"
" display.vim - 
"
" Created by skywind on 2023/06/26
" Last Modified: 2023/06/26 16:36:13
"
"======================================================================


"----------------------------------------------------------------------
" internal variable
"----------------------------------------------------------------------
let s:popup = 0
let s:opts = {}
let s:screencx = &columns
let s:screency = &lines
let s:wincx = 0
let s:wincy = 0
let s:vertical = 0
let s:position = ''

let s:bid = -1
let s:previous_wid = -1
let s:working_wid = -1

let s:popup_main = {}
let s:popup_foot = {}
let s:popup_head = {}
let s:popup_split = {}


"----------------------------------------------------------------------
" internal functions
"----------------------------------------------------------------------
function! s:config(what) abort
	return navigator#config#get(s:opts, a:what)
endfunc


"----------------------------------------------------------------------
" calculate
"----------------------------------------------------------------------
function! s:need_keep(vertical, position) abort
	let keep = 0
	if a:vertical == 0
		if index(['rightbelow', 'botright', 'rightbot'], a:position) >= 0
			let keep = (&splitbelow == 0)? 1 : 0
		else
			let keep = (&splitbelow != 0)? 1 : 0
		endif
	else
		if index(['rightbelow', 'botright', 'rightbot'], a:position) >= 0
			let keep = (&splitright == 0)? 1 : 0
		else
			let keep = (&splitright != 0)? 1 : 0
		endif
	endif
	return keep
endfunc


"----------------------------------------------------------------------
" window open
"----------------------------------------------------------------------
function! s:win_open() abort
	let opts = s:opts
	let vertical = s:config('vertical')
	let position = s:config('position')
	let min_height = s:config('min_height')
	let min_width = s:config('min_width')
	let s:previous_wid = winnr()
	let keep = s:need_keep(vertical, position)
	if keep
		call navigator#utils#save_view()
	endif
	if vertical == 0
		exec printf('%s %dsplit', position, min_height)
		exec printf('resize %d', min_height)
	else
		exec printf('%s %dvsplit', position, min_width)
		exec printf('vertical resize %d', min_width)
	endif
	if keep
		call navigator#utils#restore_view()
	endif
	let w:_navigator_keep = keep
	let s:working_wid = winnr()
	if s:bid < 0
		let s:bid = navigator#utils#create_buffer()
	endif
	let bid = s:bid
	exec 'b ' . bid
	setlocal bt=nofile nobuflisted nomodifiable
	setlocal nowrap nonumber nolist nocursorline nocursorcolumn noswapfile
	if has('signs') && has('patch-7.4.2210')
		setlocal signcolumn=no 
	endif
	if has('spell')
		setlocal nospell
	endif
	if has('folding')
		setlocal fdc=0
	endif
	call navigator#utils#update_buffer(bid, [])
endfunc


"----------------------------------------------------------------------
" window close
"----------------------------------------------------------------------
function! s:win_close() abort
	if s:working_wid > 0
		let keep = get(w:, '_navigator_keep', 0)
		if keep
			call navigator#utils#save_view()
		endif
		exec printf('%dclose', s:working_wid)
		if keep
			call navigator#utils#restore_view()
		endif
		let s:working_wid = -1
		if s:previous_wid > 0
			exec printf('%dwincmd w', s:previous_wid)
			let s:previous_wid = -1
		endif
	endif
endfunc


"----------------------------------------------------------------------
" window resize
"----------------------------------------------------------------------
function! s:win_resize(width, height) abort
	if s:working_wid > 0
		let keep = get(w:, '_navigator_keep', 0)
		if keep
			call navigator#utils#save_view()
		endif
		call navigator#utils#window_resize(s:working_wid, a:width, a:height)
		if keep
			call navigator#utils#restore_view()
		endif
	endif
endfunc


"----------------------------------------------------------------------
" window get size
"----------------------------------------------------------------------
function! s:win_getsize() abort
	let size = {}
	let size.w = winwidth(0)
	let size.h = winheight(0)
	return size
endfunc


"----------------------------------------------------------------------
" window update
"----------------------------------------------------------------------
function! s:win_update(textline, status) abort
	if s:bid > 0
		call navigator#utils#update_buffer(s:bid, a:textline)
		if s:working_wid > 0 && s:working_wid == winnr()
			let m = ' => '
			let t = join(a:status, m) . m
			let t .= ' %=(C-j/k: paging, BS: return, ESC: quit)'
			let &l:statusline = 'Navigator: ' . t
			setlocal ft=navigator
		endif
	endif
endfunc


"----------------------------------------------------------------------
" window execute
"----------------------------------------------------------------------
function! s:win_execute(command) abort
	if type(a:command) == type([])
		let command = join(a:command, "\n")
	elseif type(a:command) == type('')
		let command = a:command
	else
		let command = a:command
	endif
	if s:working_wid > 0
		let wid = winnr()
		noautocmd exec printf('%dwincmd w', s:working_wid)
		exec command
		noautocmd exec printf('%dwincmd w', wid)
	endif
endfunc


"----------------------------------------------------------------------
" popup: open
"----------------------------------------------------------------------
function! s:popup_open() abort
	let position = s:config('popup_position')
	let min_height = s:config('min_height')
	let min_width = s:config('min_width')
	let opts = {}
	let opts.color = 'Normal'
	let opts.bordercolor = 'Normal'
	if position == 'bottom'
		let opts.x = 0
		let opts.y = &lines - min_height - 2
		let opts.w = &columns
		let opts.h = min_height
	else
		let opts.w = s:config('popup_width')
		let opts.h = s:config('popup_height')
		let opts.x = (&columns - opts.w) / 2
		let opts.y = (&lines * 4 / 5 - opts.h) / 2
		let opts.center = 1
		let opts.border = 1
		" let opts.title = ' Navigator '
	endif
	let s:popup_main = quickui#window#new()
	call s:popup_main.open([], opts)
	if position == 'bottom'
		let op = {}
		let op.w = opts.w
		let op.h = 1
		let op.x = 0
		let op.y = &lines - 2
		let op.color = 'StatusLine'
		let op.bordercolor = 'StatusLine'
		let s:popup_foot = quickui#window#new()
		call s:popup_foot.open([], op)
		let op.y = &lines - 3 - min_height
		let op.color = 'StatusLineNC'
		let op.bordercolor = 'StatusLineNC'
		let s:popup_head = quickui#window#new()
		call s:popup_head.open([], op)
	else
	endif
endfunc


"----------------------------------------------------------------------
" win: close
"----------------------------------------------------------------------
function! s:popup_close() abort
	let position = s:config('popup_position')
	call s:popup_main.close()
	if position == 'bottom'
		call s:popup_foot.close()
		call s:popup_head.close()
	else
	endif
endfunc


"----------------------------------------------------------------------
" resize
"----------------------------------------------------------------------
function! s:popup_resize(width, height) abort
	let position = s:config('popup_position')
	if position == 'bottom'
		call s:popup_main.resize(s:popup_main.w, a:height)
		call s:popup_main.move(0, &lines - a:height - 2)
		call s:popup_head.move(0, &lines - a:height - 3)
	else
	endif
endfunc


"----------------------------------------------------------------------
" get size
"----------------------------------------------------------------------
function! s:popup_getsize() abort
	let size = {}
	let size.w = s:popup_main.w
	let size.h = s:popup_main.h
	return size
endfunc


"----------------------------------------------------------------------
" update content and statusline 
"----------------------------------------------------------------------
function! s:popup_update(content, status) abort
	let position = s:config('popup_position')
	call s:popup_main.set_text(a:content)
	" call s:popup_main.show(1)
	call s:popup_main.execute('setlocal ft=navigator')
	if position == 'bottom'
		let t = join(a:status, ' => ') . ' => '
		let t = 'Navigator: ' . t
		let r = '(C-j/k: paging, BS: return, ESC: quit)'
		let w = s:popup_foot.w
		let size = strlen(t) + strlen(r)
		let t = t . repeat(' ', w - size) . r
		call s:popup_foot.set_text([t])
	else
	endif
endfunc


"----------------------------------------------------------------------
" execute command
"----------------------------------------------------------------------
function! s:popup_execute(command)
	call s:popup_main.execute(a:command)
endfunc


"----------------------------------------------------------------------
" initialize
"----------------------------------------------------------------------
function! navigator#display#open(opts) abort
	let s:opts = a:opts
	let s:popup = s:config('popup')
	let s:vertical = s:config('vertical')
	let s:position = navigator#config#position(s:config('position'))
	let s:screencx = &columns
	let s:screency = &lines
	if s:popup == 0
		call s:win_open()
	else
		call s:popup_open()
	endif
	let size = navigator#display#getsize()
	if s:vertical == 0
		let s:wincx = size.w
		let s:wincy = s:config('min_height')
	else
		let s:wincx = s:config('min_width')
		let s:wincy = size.h
	endif
endfunc


"----------------------------------------------------------------------
" close 
"----------------------------------------------------------------------
function! navigator#display#close() abort
	if s:popup == 0
		call s:win_close()
	else
		call s:popup_close()
	endif
endfunc


"----------------------------------------------------------------------
" resize
"----------------------------------------------------------------------
function! navigator#display#resize(width, height) abort
	if s:popup == 0
		call s:win_resize(a:width, a:height)
	else
		call s:popup_resize(a:width, a:height)
	endif
endfunc


"----------------------------------------------------------------------
" get size
"----------------------------------------------------------------------
function! navigator#display#getsize() abort
	if s:popup == 0
		return s:win_getsize()
	else
		return s:popup_getsize()
	endif
endfunc


"----------------------------------------------------------------------
" update
"----------------------------------------------------------------------
function! navigator#display#update(content, status) abort
	if s:popup == 0
		call s:win_update(a:content, a:status)
	else
		call s:popup_update(a:content, a:status)
	endif
endfunc


"----------------------------------------------------------------------
" execute
"----------------------------------------------------------------------
function! navigator#display#execute(command) abort
	if s:popup == 0
		call s:win_execute(a:command)
	else
		call s:popup_execute(a:command)
	endif
endfunc


" vim: set ts=4 sw=4 tw=78 noet :

