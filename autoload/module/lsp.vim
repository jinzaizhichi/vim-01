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
	elseif exists(':CmpStatus')
		return 'cmp'
	endif
	return ''
endfunc


"----------------------------------------------------------------------
" hover
"----------------------------------------------------------------------
function! module#lsp#hover()
	let tt = module#lsp#type()
	if tt == 'coc'
		if CocAction('hasProvider', 'hover')
			call CocActionAsync('doHover')
		endif
	elseif tt == 'ycm'
		exec "normal \<Plug>(YCMHover)"
	endif
endfunc



