"======================================================================
"
" prompt.vim - 
"
" Created by skywind on 2023/07/10
" Last Modified: 2023/07/10 13:52:33
"
"======================================================================


"----------------------------------------------------------------------
" callback
"----------------------------------------------------------------------
function! s:callback(task, event, data) abort
	let task = a:task
	let bid = task.bid
	echom [a:event, a:data]
	if a:event == 'stdout'
		call appendbufline(bid, line("$") - 1, a:data)
		echom "stdout: " . a:data
		" call setbufvar(bid, '&modified', 0)
	elseif a:event == 'stderr'
		call appendbufline(bid, line("$") - 1, a:data)
		echom "stderr: " . a:data
	elseif a:event == 'exit'
	endif
endfunc


"----------------------------------------------------------------------
" prompt input
"----------------------------------------------------------------------
function! s:text_enter(text)
	let bid = bufnr('%')
	if &bt != 'prompt'
		return 
	endif
	let object = asclib#buffer#object(bid)
	if !has_key(object, 'prompt_task')
		return
	endif
	let task = object.prompt_task
	call task.send(a:text)
	echom "enter: " . a:text
endfunc


"----------------------------------------------------------------------
" open prompt buffer in current window
"----------------------------------------------------------------------
function! module#prompt#open(cmdline, opts) abort
	let opts = {}
	let task = asclib#task#new(function('s:callback'), 'prompt-task')
	exec 'new'
	let bid = bufnr('%')
	let task.bid = bid
	setlocal bt=prompt nobuflisted
	setlocal nonumber nolist nocursorline nocursorcolumn noswapfile
	let object = asclib#buffer#object(bid)
	let object.prompt_task = task
	call prompt_setcallback(bid, function('s:text_enter'))
	call task.start(a:cmdline, a:opts)
endfunc


