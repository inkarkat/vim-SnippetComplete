" TODO: summary
"
" DESCRIPTION:
" USAGE:
" INSTALLATION:
"   Put the script into your user or system Vim plugin directory (e.g.
"   ~/.vim/plugin). 

" DEPENDENCIES:
"   - Requires Vim 7.0 or higher. 

" CONFIGURATION:
" INTEGRATION:
" LIMITATIONS:
" ASSUMPTIONS:
" KNOWN PROBLEMS:
" TODO:
"
" Copyright: (C) 2009 by Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"	001	00-Jan-2009	file creation

" Avoid installing twice or when in unsupported Vim version. 
if exists('g:loaded_SnippetComplete') || (v:version < 700)
    finish
endif
let g:loaded_SnippetComplete = 1

function! s:makeSnipmateItem(key, snip)
  if type(a:snip) == type([])
    let descriptions = map(copy(a:snip), 'v:val[0]')
    let snipFormatted = '[MULTI] ' . join(descriptions, ', ')
  else
    let snipFormatted = substitute(a:snip, '\(\n\|\s\)\+', ' ', 'g')
  endif
  return  {
        \   'word': a:key,
        \   'menu': strpart(snipFormatted, 0, 80),
        \ }
endfunction

"
function! s:getMatchingSnipItems(base)
  let key = a:base . "\n"
  if !exists('s:snipItems[key]')
    let s:snipItems[key] = items(GetSnipsInCurrentScope())
    call filter(s:snipItems[key], 'strpart(v:val[0], 0, len(a:base)) ==? a:base')
    call map(s:snipItems[key], 's:makeSnipmateItem(v:val[0], v:val[1])')
  endif
  return s:snipItems[key]
endfunction

fun! ShowAvailableSnips()
	let line  = getline('.')
	let col   = col('.')
	let word  = matchstr(getline('.'), '\S\+\%'.col.'c')
	let words = [word]
	if stridx(word, '.')
		let words += split(word, '\.', 1)
	endif
	let matchlen = 0
	let matches = []
	for scope in [bufnr('%')] + split(&ft, '\.') + ['_']
		let triggers = has_key(s:snippets, scope) ? keys(s:snippets[scope]) : []
		if has_key(s:multi_snips, scope)
			let triggers += keys(s:multi_snips[scope])
		endif
		for trigger in triggers
			for word in words
				if word == ''
					let matches += [trigger] " Show all matches if word is empty
				elseif trigger =~ '^'.word
					let matches += [trigger]
					let len = len(word)
					if len > matchlen | let matchlen = len | endif
				endif
			endfor
		endfor
	endfor

	" This is to avoid a bug with Vim when using complete(col - matchlen, matches)
	" (Issue#46 on the Google Code snipMate issue tracker).
	call setline(line('.'), substitute(line, repeat('.', matchlen).'\%'.col.'c', '', ''))
	call complete(col, matches)
	return ''
endf 

function! s:GetAbbreviations()
    let l:abbreviations = ''
    let l:save_verbose = &verbose
    try
	set verbose=0	" Do not include any "Last set from" info. 
	redir => l:abbreviations
	silent iabbrev
    finally
	redir END
	let &verbose = l:save_verbose
    endtry

    let l:matches = []
    try
	for l:abb in split(l:abbreviations, "\n")
	    let [l:lhs, l:flags, l:rhs] = matchlist(l:abb, '^\S\s\+\(\S\+\)\s\+\([* ][@ ]\)\(.*\)$')[1:3]
	    let l:match = { 'word': l:lhs, 'menu': l:rhs }
	    call add(l:matches, l:match)
	endfor
    catch /^Vim\%((\a\+)\)\=:E688/	" catch error E688: More targets than List items
	" When there are no abbreviations, Vim returns "No abbreviation found". 
    endtry
    return l:matches
endfunction

function! s:SnippetComplete()
    call complete(col('.'), s:GetAbbreviations())
    return ''
endfunction

inoremap <silent> <C-x><C-]> <C-r>=<SID>SnippetComplete()<CR>

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :

