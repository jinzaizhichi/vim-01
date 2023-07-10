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
	" echom [a:event, a:data]
	if a:event == 'stdout'
		call appendbufline(bid, line("$") - 1, a:data)
		echom "stdout: " . a:data
		" call setbufvar(bid, '&modified', 0)
	elseif a:event == 'stderr'
		call appendbufline(bid, line("$") - 1, a:data)
		" echom "stderr: " . a:data
	elseif a:event == 'exit'
		echom "exit: " . a:data
		if bufexists(bid)
			" call setbufvar(bid, '&bt', 'nofile')
			call setbufvar(bid, '&modifiable', 0)
			call setbufvar(bid, '&modified', 0)
			call setbufvar(bid, '&readonly', 1)
			if bufnr('%') == bid
				if mode(1) =~ 'i'
					stopinsert
				endif
			endif
			echom "here: " . bid
		endif
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
	" call asclib#buffer#autocmd(bid, 'BufUnload', function('s:event_unload'))
	" call asclib#buffer#autocmd(bid, 'BufDelete', function('s:event_delete'))
	call task.start(a:cmdline, a:opts)
	if task.status() != 'none'
		call setbufvar(bid, '&modified', 1)
	endif
endfunc


"----------------------------------------------------------------------
" event: unload
"----------------------------------------------------------------------
function! s:event_unload()
	let bid = str2nr(expand('<abuf>'))
	let object = asclib#buffer#object(bid)
	if !has_key(object, 'prompt_task')
		return
	endif
	let task = object.prompt_task
	let status = task.status()
	if status != 'none'
		call task.stop('term')
		echom 'task stop'
	endif
endfunc


"----------------------------------------------------------------------
" event: delete
"----------------------------------------------------------------------
function! s:event_delete()
	let bid = str2nr(expand('<abuf>'))
	let object = asclib#buffer#object(bid)
	unsilent echom "buffer delete " . bid
endfunc



"----------------------------------------------------------------------
" events
"----------------------------------------------------------------------
augroup ModulePromptEvents
	au!
	autocmd BufUnload * call s:event_unload()
	autocmd BufDelete * call s:event_delete()
augroup END



