"======================================================================
"
" compat.vim - 
"
" Created by skywind on 2023/08/30
" Last Modified: 2023/08/30 15:27:59
"
"======================================================================


"----------------------------------------------------------------------
" jump word
"----------------------------------------------------------------------
function! module#compat#easymotion_word()
	if mapcheck("<plug>(easymotion-bd-w)", 'n') != ''
		call feedkeys("\<plug>(easymotion-bd-w)")
	elseif exists(':HopWord')
		exec 'HopWord'
	endif
endfunc


