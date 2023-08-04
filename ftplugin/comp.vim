"======================================================================
"
" comp.vim - 
"
" Created by skywind on 2023/08/04
" Last Modified: 2023/08/04 14:22:42
"
"======================================================================

" key names
let s:text_keys = {
			\ 'command': 'shell command, or EX-command (starting with :)',
			\ 'cwd': "working directory, use `:pwd` when absent",
			\ 'output': '"quickfix" or "terminal"',
			\ 'pos': 'terminal position or the name of a runner', 
			\ 'errorformat': 'error matching rules in the quickfix window',
			\ 'save': 'whether to save modified buffers before task start',
			\ 'option': 'arbitrary string to pass to the runner',
			\ 'focus': 'whether to focus on the task terminal',
			\ 'close': 'to close the task terminal when task is finished',
			\ 'program': 'command modifier',
			\ 'notify': 'notify a message when task is finished',
			\ 'strip': 'trim header+footer in the quickfix',
			\ 'scroll': 'is auto-scroll allowed in the quickfix',
			\ 'encoding': 'task stdin/stdout encoding',
			\ 'once': 'buffer output and flush when job is finished',
			\ }

let s:text_system = {
			\ 'win32': '<for windows only>',
			\ 'linux': '<for linux only>',
			\ 'darwin': '<for macOS only>',
			\ }

"----------------------------------------------------------------------
" standard GPT generated function
"----------------------------------------------------------------------
function! MyOmniFunc(findstart, base)
	" If findstart is non-zero, return the column number of the start of the word
	if a:findstart
		let line = getline('.')
		let start = col('.') - 1
		while start > 0 && line[start - 1] =~ '\w'
			let start -= 1
		endwhile
		echom printf("first: pos=%d start=%d", col('.'), start)
		return start
	else
		" If findstart is zero, return a list of completions for the base
		let completions = []
		if a:base == 'foo'
			call add(completions, 'foobar')
			call add(completions, 'foobaz')
		elseif a:base == 'bar'
			call add(completions, 'barfoo')
			call add(completions, 'barbaz')
		endif
		echom printf("second: pos=%d base='%s'", col('.'), a:base)
		return completions
	endif
endfunction


"----------------------------------------------------------------------
" experimental function
"----------------------------------------------------------------------
function! MyOmniFunc2(findstart, base)
	" If findstart is non-zero, return the column number of the start of the word
	if a:findstart
		let ctx = asclib#mcm#context()
		let matched = strlen(matchstr(ctx, '\w\+$'))
		let start = col('.') - matched - 1
		echom printf("first: pos=%d start=%d matched=%d", col('.'), start, matched)
		return start
	else
		" If findstart is zero, return a list of completions for the base
		let completions = []
		if a:base == 'foo'
			call add(completions, 'foobar')
			call add(completions, 'foobaz')
		elseif a:base == 'bar'
			call add(completions, 'barfoo')
			call add(completions, 'barbaz')
		endif
		echom printf("second: pos=%d base='%s'", col('.'), a:base)
		return completions
	endif
endfunction


"----------------------------------------------------------------------
" 
"----------------------------------------------------------------------
function! MyOmniFunc3(findstart, base) abort
	if a:findstart
		let ctx = asclib#mcm#context()
		let matched = strchars(matchstr(ctx, '\w\+$'))
		let pos = col('.')
		if ctx =~ '^\s*#'
			let start = pos - 1
		elseif ctx =~ '^\s*['
			let start = pos - 1
		elseif stridx(ctx, '=') < 0
			let start = pos - matched - 1
		else
			if ctx =~ '\$$'
				let start = pos - 1 - 1
			elseif ctx =~ '\$($'
				let start = pos - 2 - 1
			elseif ctx =~ '\$(\w\+$'
				let start = pos - 2 - matched - 1
			else
				let start = pos - matched - 1
			endif
		endif
		return start
	else
		let ctx = asclib#mcm#context()
		if ctx =~ '^\s*#'
			return v:none
		elseif ctx =~ '^\s*['
			return v:none
		elseif stridx(ctx, '=') < 0
			if stridx(ctx, ':') < 0
				return asclib#mcm#match_complete(a:base, s:text_keys, 'k', 1)
			elseif stridx(ctx, '/') < 0
				if !exists('s:ft_cache')
					let s:ft_cache = asyncrun#compat#list_fts()
					call sort(s:ft_cache)
				endif
				return asclib#mcm#match_complete(a:base, s:ft_cache, 'f', 0)
			else
				return asclib#mcm#match_complete(a:base, s:text_system, 's', 1)
			endif
		else
		endif
		return v:none
	endif
endfunc


setlocal omnifunc=MyOmniFunc3


