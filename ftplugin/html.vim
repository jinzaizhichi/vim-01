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

let b:navigator.z = {
	\ 'name': '+zen-code',
	\ ';': ['<key><c-z>;', 'expand-word'],
	\ ',': ['<key><c-z>,', 'expand-abbreviation'],
	\ 'u': ['<key><c-z>u', 'update-tag'],
	\ 'd': ['<key><c-z>d', 'balance-tag-inward'],
	\ 'D': ['<key><c-z>D', 'balance-tag-outward'],
	\ 'n': ['<key><c-z>n', 'next-edit-point'],
	\ 'N': ['<key><c-z>N', 'prev-edit-point'],
	\ 'i': ['<key><c-z>i', 'update-image-size'],
	\ 'm': ['<key><c-z>m', 'merge-lines'],
	\ 'k': ['<key><c-z>k', 'remove-tag'],
	\ 'j': ['<key><c-z>j', 'split-join-tag'],
	\ '/': ['<key><c-z>/', 'toggle-comment'],
	\ 'a': ['<key><c-z>a', 'make-anchor-url'],
	\ 'A': ['<key><c-z>A', 'quoted-text-url'],
	\ 'c': ['<key><c-z>c', 'code-pretty'],
	\ }

let b:navigator_insert.z = deepcopy(b:navigator.z)



"----------------------------------------------------------------------
" install zen-coding
"----------------------------------------------------------------------


