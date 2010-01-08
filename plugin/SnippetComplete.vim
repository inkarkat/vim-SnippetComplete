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

let s:abbreviationExpressions = [['fullid', '\k*'], ['endid', '\%(\k\@!\S\)\+\k\?'], ['nonid', '\S\+\%(\k\@!\S\)\?']]
function! s:DetermineBaseCol()
    " Locate the start of the abbreviation, searching for full-id, end-id and
    " non-id abbreviations. 
    " If the insertion started in the current line, only consider characters
    " that were inserted by the last insertion. For this, we match with the
    " start-of-insert mark '[; This mark may (or not) be in the current line,
    " but the matched text must definitely be somewhere after it. With this
    " combination, only freshly inserted text is matched if insertion started in
    " the current line, but all text in the line may match when inserted started
    " above the current line. 
    let l:baseColumns = []
    for l:abbreviationExpression in s:abbreviationExpressions
	let l:startCol = searchpos('\%(\%''[.\)\?\%>''[\%(' . l:abbreviationExpression[1] . '\)\%#', 'bn', line('.'))[1]
	if l:startCol != 0
	    call add(l:baseColumns, [l:abbreviationExpression[0], l:startCol])
	endif
    endfor
    if empty(l:baseColumns)
	call add(l:baseColumns, ['none', col('.')])
    endif
    return l:baseColumns
endfunction

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

    let l:globalMatches = []
    let l:localMatches = []
    try
	for l:abb in split(l:abbreviations, "\n")
	    let [l:lhs, l:flags, l:rhs] = matchlist(l:abb, '^\S\s\+\(\S\+\)\s\+\([* ][@ ]\)\(.*\)$')[1:3]
	    let l:match = { 'word': l:lhs, 'menu': l:rhs }
	    call add((l:flags =~# '@' ? l:localMatches : l:globalMatches), l:match)
	endfor
    catch /^Vim\%((\a\+)\)\=:E688/	" catch error E688: More targets than List items
	" When there are no abbreviations, Vim returns "No abbreviation found". 
    endtry

    " A buffer-local abbreviation overrides an existing global abbreviation with
    " the same {lhs}. 
    for l:localWord in map(copy(l:localMatches), 'v:val.word')
	call filter(l:globalMatches, 'v:val.word !=# ' . string(l:localWord))
    endfor
    return l:globalMatches + l:localMatches
endfunction

function! s:MatchAbbreviations( matches, baseCol )
    let l:base = strpart(getline('.'), a:baseCol - 1, (col('.') - a:baseCol))
"****D echomsg '****' a:baseCol l:base

    if empty(l:base)
	return a:matches
    else
	return filter(copy(a:matches), 'v:val.word =~# ''^\V'' . ' . string(escape(l:base, '\')))
    endif
endfunction
function! s:SnippetComplete()
    let l:baseColumns = s:DetermineBaseCol()
    let l:abbreviations = s:GetAbbreviations()
echomsg '####' string(l:baseColumns)

    for [l:abbreviationType, l:baseCol] in l:baseColumns
	let l:matches = s:MatchAbbreviations(l:abbreviations, l:baseCol)
	echomsg '****' l:abbreviationType string(l:matches)
    endfor

    "call complete(l:baseCol, l:matches)
    return ''
endfunction

inoremap <silent> <Plug>SnippetComplete <C-r>=<SID>SnippetComplete()<CR>
if ! hasmapto('<Plug>SnippetComplete', 'i')
    imap <C-x><C-]> <Plug>SnippetComplete
endif

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :

