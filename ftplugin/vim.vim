set ff=unix
let b:cursorword = 1

let b:navigator_insert = {}
let b:navigator_insert.i = {
			\ 'c': ['<key>windows<m-e>', 'windows-checker'],
			\ 's': ['<key>scripthome<m-e>', 'script-home-detector'],
			\ 't': ['<key>try<m-e>', 'insert-try-catch'],
			\ 'w': ['<key>while<m-e>', 'insert-while-endwhile'],
			\ }


	
