"======================================================================
"
" comp.vim - 
"
" Created by skywind on 2023/08/04
" Last Modified: 2023/08/04 14:22:42
"
"======================================================================


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


setlocal omnifunc=MyOmniFunc2


