runtime plugin/SidTools.vim
silent! call SnippetComplete#DoesNotExist()

let s:SID = Sid('autoload/SnippetComplete.vim')
call vimtest#ErrorAndQuitIf(s:SID <= 0, "Failed to determine script's SID")
function! DetermineBaseCol()
    return SidInvoke(s:SID, 'DetermineBaseCol(g:SnippetComplete_AbbreviationTypes)')
endfunction
function! GetSnippetCompletions()
    return SidInvoke(s:SID, 'GetSnippetCompletions(g:SnippetComplete_AbbreviationTypes)')
endfunction
function! IsMatches( base, expectedCompletionsByBaseCol, description )
    1delete _
    execute 'normal! a' . a:base . ' '

    let l:completionsByBaseCol = GetSnippetCompletions()

    for l:baseCol in keys(l:completionsByBaseCol)
	call map(l:completionsByBaseCol[l:baseCol], 'v:val.word')
	call sort(l:completionsByBaseCol[l:baseCol])
    endfor
    call vimtap#Is(l:completionsByBaseCol, a:expectedCompletionsByBaseCol, a:description)
endfunction

