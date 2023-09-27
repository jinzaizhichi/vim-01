"======================================================================
"
" html.vim - 
"
" Created by skywind on 2023/09/26
" Last Modified: 2023/09/26 15:27:41
"
"======================================================================

let b:navigator = { 'prefix': '<tab><tab>' }
let b:navigator_insert = { 'prefix': '<c-\><c-\>' }

let b:navigator.c = {
	\ 'name': '+coding',
	\ ';': ['<key><c-z>;', 'emmet-expand-word'],
	\ ',': ['<key><c-z>,', 'emmet-expand-abbreviation'],
	\ 'u': ['<key><c-z>u', 'emmet-update-tag'],
	\ 'd': ['<key><c-z>d', 'emmet-balance-tag-inward'],
	\ 'D': ['<key><c-z>D', 'emmet-balance-tag-outward'],
	\ 'n': ['<key><c-z>n', 'emmet-next-edit-point'],
	\ 'N': ['<key><c-z>N', 'emmet-prev-edit-point'],
	\ 'i': ['<key><c-z>i', 'emmet-update-image-size'],
	\ 'm': ['<key><c-z>m', 'emmet-merge-lines'],
	\ 'k': ['<key><c-z>k', 'emmet-remove-tag'],
	\ 'j': ['<key><c-z>j', 'emmet-split-join-tag'],
	\ '/': ['<key><c-z>/', 'emmet-toggle-comment'],
	\ 'a': ['<key><c-z>a', 'emmet-make-anchor-url'],
	\ 'A': ['<key><c-z>A', 'emmet-quoted-text-url'],
	\ 'c': ['<key><c-z>c', 'emmet-code-pretty'],
	\ }

let b:navigator_insert.c = deepcopy(b:navigator.c)



"----------------------------------------------------------------------
" install zen-coding
"----------------------------------------------------------------------


