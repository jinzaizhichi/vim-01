"======================================================================
"
" navigator.vim - 
"
" Created by skywind on 2023/06/27
" Last Modified: 2023/06/27 15:47:23
"
"======================================================================

let s:context = navigator#config#fetch('context', {})

if !has_key(s:context, 'page')
	finish
endif

let s:padding = s:context.padding
let s:spacing = s:context.spacing
let s:page = s:context.page
let s:content = s:page.content
let s:icon_separator = navigator#config#get(s:context.ctx, 'icon_separator')

let s:position = repeat([0], len(s:page.cowidth))
let s:width = repeat([0], len(s:page.cowidth))
let startx = s:padding[0]

for i in range(len(s:position))
	let s:position[i] = startx
	let s:width[i] = s:page.cowidth[i]
	let startx += s:width[i]
	let startx += s:spacing
endfor


"----------------------------------------------------------------------
" color the hole buffer
"----------------------------------------------------------------------
function! s:color_buffer()
	for y in range(len(s:content))
		let text = s:content[y]
		if text =~ '^\s*$'
			continue
		endif
		" unsilent echom 'y: '. y
		for i in range(len(s:position))
			let x = s:position[i]
			let w = s:width[i]
			call s:color_item(text, x, w, y)
		endfor
	endfor
endfunc


"----------------------------------------------------------------------
" color item
"----------------------------------------------------------------------
function! s:color_item(text, pos, width, y) abort
	let part = strpart(a:text, a:pos, a:width)
	let head = strpart(part, 0, 3)
	" echom printf("%2d,%2d,%2d: %s", a:y, a:pos, a:width, part)
endfunc

syn clear

call s:color_buffer()

echo s:position
echo s:icon_separator


