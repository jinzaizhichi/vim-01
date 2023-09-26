"======================================================================
"
" emmet.vim - 
"
" Created by skywind on 2023/09/26
" Last Modified: 2023/09/26 14:43:47
"
"======================================================================

let g:user_emmet_install_global = 0

" let g:user_emmet_mode='n'    "only enable normal mode functions.
" let g:user_emmet_mode='inv'  "enable all functions, which is equal to
" let g:user_emmet_mode='a'    "enable all function in all mode.
let g:user_emmet_mode = 'iv'

let g:user_emmet_leader_key='<C-Y>'


"----------------------------------------------------------------------
" augroup
"----------------------------------------------------------------------
augroup MyEmmetEvents
	au!
	if exists(':EmmetInstall') == 2
		autocmd FileType html,css EmmetInstall
	endif
augroup END


