"======================================================================
"
" test_visual.vim - 
"
" Last Modified: 2023/07/26 00:39
"
"======================================================================


"----------------------------------------------------------------------
" 
"----------------------------------------------------------------------
function! TestVisual()
	let l1 = expand('<line1>')
	let l2 = expand('<line2>')
	let la = expand('<aline>')
	echom printf("mode=%s <line1>=%d <line2>=%d <aline>=%d", mode(1), l1, l2, la)
endfunc

command! TestVisual1 call TestVisual()
command! -rang TestVisual2 call TestVisual()

vnoremap <space>kk :TestVisual2<cr>

messages clear


