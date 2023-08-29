"======================================================================
"
" lsp.vim - 
"
" Created by skywind on 2023/08/29
" Last Modified: 2023/08/29 17:10:58
"
"======================================================================


"----------------------------------------------------------------------
" check type
"----------------------------------------------------------------------
function! module#lsp#type()
	if exists(':YcmCompleter')
		return 'ycm'
	elseif exists(':CocInstall')
		return 'coc'
	endif
	return ''
endfunc



