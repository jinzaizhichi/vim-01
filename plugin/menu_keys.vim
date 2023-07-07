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
			\ '1' : [':b1'        , 'buffer 1']        ,
			\ '2' : [':b2'        , 'buffer 2']        ,
			\ 'd' : [':bd'        , 'delete-buffer']   ,
			\ 'f' : [':bfirst'    , 'first-buffer']    ,
			\ 'h' : [':Startify'  , 'home-buffer']     ,
			\ 'l' : [':blast'     , 'last-buffer']     ,
			\ 'n' : [':bnext'     , 'next-buffer']     ,
			\ 'p' : [':bprevious' , 'previous-buffer'] ,
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
			\ '1' : ['<key>1gt', 'tab-1'],
			\ '2' : ['<key>2gt', 'tab-2'],
			\ '3' : ['<key>3gt', 'tab-3'],
			\ '4' : ['<key>4gt', 'tab-4'],
			\ '5' : ['<key>5gt', 'tab-5'],
			\ '6' : ['<key>6gt', 'tab-6'],
			\ '7' : ['<key>7gt', 'tab-7'],
			\ '8' : ['<key>8gt', 'tab-8'],
			\ '9' : ['<key>9gt', 'tab-9'],
			\ }


"----------------------------------------------------------------------
" search
"----------------------------------------------------------------------
let g:navigator.s = {
			\ 'name': '+search',
			\ 's': ['MenuHelp_Fscope("s")', 'gscope-find-symbol'],
			\ 'g': ['MenuHelp_Fscope("g")', 'gscope-find-definition'],
			\ 'c': ['MenuHelp_Fscope("c")', 'gscope-find-calling'],
			\ 'd': ['MenuHelp_Fscope("d")', 'gscope-find-called'],
			\ 'e': ['MenuHelp_Fscope("e")', 'gscope-find-pattern'],
			\ 't': ['MenuHelp_Fscope("t")', 'gscope-find-text'],
			\ 'a': ['MenuHelp_Fscope("a")', 'gscope-find-assigned'],
			\ 'f': ['MenuHelp_Fscope("f")', 'gscope-find-file'],
			\ 'i': ['MenuHelp_Fscope("i")', 'gscope-find-include'],
			\ 'z': ['MenuHelp_Fscope("z")', 'gscope-find-ctags'],
			\ }


"----------------------------------------------------------------------
" open
"----------------------------------------------------------------------
let g:navigator.o = {
			\ 'name': '+open-files',
			\ 'r' : [':Leaderf mru', 'leaderf-recent-files'],
			\ 'p' : [':Leaderf mru', 'leaderf-project-files'],
			\ }


"----------------------------------------------------------------------
" project
"----------------------------------------------------------------------
let g:navigator.p = {
			\ 'name': '+project',
			\ 'c' : ['module#project#open("CMakeLists.txt")', 'edit-cmake-lists'],
			\ 't' : ['module#project#open(".tasks")', 'edit-task-list'],
			\ 'r' : ['module#project#open("README.md")', 'edit-readme-md'],
			\ 'i' : ['module#project#open(".gitignore")', 'edit-git-ignore'],
			\ }


"----------------------------------------------------------------------
" help
"----------------------------------------------------------------------
let g:navigator.h = {
			\ 'name': '+help',
			\ 'b' : [':Help bash', 'bash-cheatsheet'],
			\ 'v' : [':Help vim', 'vim-cheatsheet'],
			\ 'g' : [':Help gdb', 'gdb-cheatsheet'],
			\ 'G' : [':Help git', 'git-cheatsheet'],
			\ 'n' : [':Help nano', 'nano-cheatsheet'],
			\ }


"----------------------------------------------------------------------
" Easymotion
"----------------------------------------------------------------------
let g:navigator.m = ['<plug>(easymotion-bd-w)', 'easy-motion-bd-w']
let g:navigator.n = ['<plug>(easymotion-s)', 'easy-motion-s']


"----------------------------------------------------------------------
" windows
"----------------------------------------------------------------------
if has('win32') || has('win64')
	let g:navigator[','] = [':OpenShell cmdclink', 'open-cmd-here']
	let g:navigator['-'] = [':OpenShell explorer', 'open-explorer-here']
endif

let g:navigator[';'] = ['bufferhint#Popup()', 'open-buffer-hint']




"----------------------------------------------------------------------
" trigger
"----------------------------------------------------------------------
noremap <silent><tab><tab> :call navigator#cmd(g:navigator, '<tab><tab>')<cr>
" noremap <silent><tab><tab> :Navigator '<tab>'<cr>




