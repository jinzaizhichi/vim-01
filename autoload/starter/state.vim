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
let s:state = 0
let s:opened = 0
let s:prefix = ''


"----------------------------------------------------------------------
" internal
"----------------------------------------------------------------------
function! s:config(what) abort
	return starter#config#get(s:opts, a:what)
endfunc


"----------------------------------------------------------------------
" init keymap
"----------------------------------------------------------------------
function! starter#state#init(keymap, opts) abort
	let s:keymap = a:keymap
	let s:opts = a:opts
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
endfunc


