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

let s:position = repeat([0], len(s:page.cowidth))
let s:width = repeat([0], len(s:page.cowidth))
let startx = s:padding[0]

for i in range(len(s:position))
	let s:position[i] = startx
	let s:width[i] = s:page.cowidth[i]
	let startx += s:width[i]
	let startx += s:spacing
endfor

echo s:position

