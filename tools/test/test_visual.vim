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
	let lc = expand('<count>')
	echom printf("mode=%s <line1>=%d <line2>=%d <aline>=%d <count>=%d", mode(1), l1, l2, la, lc)
endfunc

"----------------------------------------------------------------------
" 
"----------------------------------------------------------------------
function! DemoVisual(line1, line2, mods, args)
	let x1 = line('v')
	let x2 = line('.')
	exec 'normal gv'
	let t = printf("mode=%s line1=%d line2=%d mods=%s", mode(1), a:line1, a:line2, a:mods)
	let t .= printf(' l1=%s l2=%s', getpos("'<"), getpos("'>"))
	let t .= printf(' x1=%d x2=%d', x1, x2)
	let t .= printf(' args="%s"', a:args)
	exec 'echom t'
	call feedkeys('=')
endfunc


command! TestVisual1 call TestVisual()
command! -rang -count TestVisual2 call TestVisual()
command! -nargs=* -rang DemoVisual call DemoVisual(<line1>, <line2>, '<q-mods>', <q-args>)

vnoremap <space>kk :TestVisual2<cr>
vnoremap <space>hh :DemoVisual \<esc><cr>
vnoremap <space>l1 :call DemoVisual(1, 2, '3')<cr>

messages clear


