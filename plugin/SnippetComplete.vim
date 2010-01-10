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
"   - Getting and sorting of matches when 'ignorecase' is on. 
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

let s:abbreviationExpressions = [['fullid', '\k\+'], ['endid', '\%(\k\@!\S\)\+\k\?'], ['nonid', '\S\+\%(\k\@!\S\)\?']]
function! s:DetermineBaseCol()
"*******************************************************************************
"* PURPOSE:
"   Check the text before the cursor to determine possible base columns where
"   abbreviations of the various types may start. 
"* ASSUMPTIONS / PRECONDITIONS:
"   None. 
"* EFFECTS / POSTCONDITIONS:
"   None. 
"* INPUTS:
"   None. 
"* RETURN VALUES: 
"   List of possible base columns, more stringently defined and shorter
"   abbreviation types come first. Each element consists of a [abbreviationType,
"   baseCol] tuple. 
"*******************************************************************************
    " Locate possible start positions of the abbreviation, searching for
    " full-id, end-id and non-id abbreviations. 
    " If the insertion started in the current line, only consider characters
    " that were inserted by the last insertion. For this, we match with the
    " stored start position of the current insert mode, if insertion started in
    " the current line. The matched text must definitely be somewhere after it,
    " but need not start with the start-of-insert position. 
    let l:insertedTextExpr = (line('.') == s:lastInsertStartPosition[1] ? '\%(\%' . s:lastInsertStartPosition[2] . 'c.\)\?\%>' . s:lastInsertStartPosition[2] . 'c.*\%#\&' : '')
    let l:baseColumns = []
    for l:abbreviationExpression in s:abbreviationExpressions
	let l:startCol = searchpos(l:insertedTextExpr . '\%(' . l:abbreviationExpression[1] . '\)\%#', 'bn', line('.'))[1]
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

function! s:MatchAbbreviations( abbreviations, abbreviationFilterExpr, baseCol )
    let l:base = strpart(getline('.'), a:baseCol - 1, (col('.') - a:baseCol))
"****D echomsg '****' a:baseCol l:base

    let l:filter = 'v:val.word =~#' . string(a:abbreviationFilterExpr)
    if ! empty(l:base)
	let l:filter .= ' && v:val.word =~# ''^\V'' . ' . string(escape(l:base, '\'))
    endif
    return filter(copy(a:abbreviations), l:filter)
endfunction
let s:filterExpr = {
\   'fullid': '^\k\+$',
\   'endid': '^\%(\k\@\!\S\)\+\k$',
\   'nonid': '^\S*\%(\k\@!\S\)$',
\   'none': '^\S\+$'
\}
function! s:GetAbbreviationCompletions()
    let l:baseColumns = s:DetermineBaseCol()
    let l:abbreviations = s:GetAbbreviations()
"****D echomsg '####' string(l:baseColumns)

    let l:completionsByBaseCol = {}
    for [l:abbreviationType, l:baseCol] in l:baseColumns
	let l:matches = s:MatchAbbreviations(l:abbreviations, s:filterExpr[l:abbreviationType], l:baseCol)
"****D echomsg '****' l:abbreviationType string(l:matches)
	if ! empty(l:matches)
	    let l:completions = get(l:completionsByBaseCol, l:baseCol, [])
	    let l:completions += l:matches
	    let l:completionsByBaseCol[l:baseCol] = l:completions
	endif
    endfor
"****D echomsg '****' string(l:completionsByBaseCol)
    return l:completionsByBaseCol
endfunction
function! s:CompletionCompare( c1, c2 )
    return (a:c1.word ==# a:c2.word ? 0 : a:c1.word ># a:c2.word ? 1 : -1)
endfunction
function! s:SnippetComplete()
    let l:completionsByBaseCol = s:GetAbbreviationCompletions()
    let l:baseColumns = reverse(sort(keys(l:completionsByBaseCol)))

    if ! empty(l:baseColumns)
	call complete(l:baseColumns[0], sort(l:completionsByBaseCol[l:baseColumns[0]], 's:CompletionCompare'))
    endif
    return ''
endfunction

" In order to determine the base column of the completion, we need the start
" position of the current insertion. Mark '[ isn't set until we (at least
" temporarily via i_CTRL-O) move out of insert mode; however doing so then
" prevents the completed abbreviation from being expanded: The insertion was
" interrupted, and Vim doesn't consider the full expanded abbreviation to have
" been inserted in the current insert mode. 
" To work around this, we use an autocmd to capture the cursor position whenever
" insert mode is entered. 
augroup SnippetComplete
    autocmd!
    autocmd InsertEnter * let s:lastInsertStartPosition = getpos('.')
augroup END

inoremap <silent> <Plug>SnippetComplete <C-r>=<SID>SnippetComplete()<CR>
if ! hasmapto('<Plug>SnippetComplete', 'i')
    imap <C-x><C-]> <Plug>SnippetComplete
endif

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
