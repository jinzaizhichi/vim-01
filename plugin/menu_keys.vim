"======================================================================
"
" menu_keys.vim - vim-navigator initialize
"
" Created by skywind on 2023/06/27
" Last Modified: 2023/06/27 22:10:10
"
"======================================================================

let g:navigator = {}


"----------------------------------------------------------------------
" buffer
"----------------------------------------------------------------------
let g:navigator.b = {
			\ 'name' : '+buffer' ,
			\ '1' : ['b1'        , 'buffer 1']        ,
			\ '2' : ['b2'        , 'buffer 2']        ,
			\ 'd' : ['bd'        , 'delete-buffer']   ,
			\ 'f' : ['bfirst'    , 'first-buffer']    ,
			\ 'h' : ['Startify'  , 'home-buffer']     ,
			\ 'l' : ['blast'     , 'last-buffer']     ,
			\ 'n' : ['bnext'     , 'next-buffer']     ,
			\ 'p' : ['bprevious' , 'previous-buffer'] ,
			\ '?' : [':Leaderf buffer'   , 'fzf-buffer']      ,
			\ }


"----------------------------------------------------------------------
" window
"----------------------------------------------------------------------
let g:navigator.w = {
			\ 'name': '+window',
			\ 'p': ['wincmd p', 'jump-previous-window'],
			\ 'h': ['wincmd h', 'jump-left-window'],
			\ 'j': ['wincmd j', 'jump-belowing-window'],
			\ 'k': ['wincmd k', 'jump-aboving-window'],
			\ 'l': ['wincmd l', 'jump-right-window'],
			\ 'H': ['wincmd H', 'move-window-to-left'],
			\ 'J': ['wincmd J', 'move-window-to-bottom'],
			\ 'K': ['wincmd K', 'move-window-to-top'],
			\ 'L': ['wincmd L', 'move-window-to-right'],
			\ 'n': ['wincmd n', 'new-window'],
			\ 'q': ['wincmd q', 'close-window'],
			\ 'w': ['wincmd w', 'jump-next-window'],
			\ 'o': ['wincmd o', 'close-all-other-windows'],
			\ 'v': ['wincmd v', 'vertically-split-window'],
			\ 's': ['wincmd s', 'split-window'],
			\ '1': ['1wincmd w', 'window-1'],
			\ '2': ['2wincmd w', 'window-2'],
			\ '3': ['3wincmd w', 'window-3'],
			\ '4': ['4wincmd w', 'window-4'],
			\ '5': ['5wincmd w', 'window-5'],
			\ '/': [':Leaderf window', 'search-for-a-window'],
			\ }


"----------------------------------------------------------------------
" tab
"----------------------------------------------------------------------
let g:navigator.t = {
			\ 'name': '+tab',
			\ 'c' : [':tabnew', 'new-tab'],
			\ 'q' : [':tabclose', 'close-tab'],
			\ 'n' : [':tabnext', 'next-tab'],
			\ 'p' : [':tabprev', 'previous-tab'],
			\ 'o' : [':tabonly', 'close-all-other-tabs'],
			\ 'l' : [':-tabmove', 'move-tab-left'],
			\ 'r' : [':+tabmove', 'move-tab-right'],
			\ '0' : [':tabn 10', 'tab-10'],
			\ '1' : [':tabn 1', 'tab-1'],
			\ '2' : [':tabn 2', 'tab-2'],
			\ '3' : [':tabn 3', 'tab-3'],
			\ '4' : [':tabn 4', 'tab-4'],
			\ '5' : [':tabn 5', 'tab-5'],
			\ '6' : [':tabn 6', 'tab-6'],
			\ '7' : [':tabn 7', 'tab-7'],
			\ '8' : [':tabn 8', 'tab-8'],
			\ '9' : [':tabn 9', 'tab-9'],
			\ }


"----------------------------------------------------------------------
" search
"----------------------------------------------------------------------
let g:navigator.s = {
			\ 'name': '+search',
			\ 's': [':VimScope s', 'gscope-find-symbol'],
			\ 'g': [':VimScope g', 'gscope-find-definition'],
			\ 'c': [':VimScope c', 'gscope-find-calling'],
			\ 'd': [':VimScope d', 'gscope-find-called'],
			\ 'e': [':VimScope e', 'gscope-find-pattern'],
			\ 't': [':VimScope t', 'gscope-find-text'],
			\ 'a': [':VimScope a', 'gscope-find-assigned'],
			\ 'f': [':VimScope f', 'gscope-find-file'],
			\ 'i': [':VimScope i', 'gscope-find-include'],
			\ }


"----------------------------------------------------------------------
" trigger
"----------------------------------------------------------------------
noremap <silent><tab><tab> :call navigator#cmd(g:navigator, '<tab><tab>')<cr>
" noremap <silent><tab><tab> :Navigator '<tab>'<cr>




