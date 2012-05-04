runtime plugin/SidTools.vim
silent! call SnippetComplete#DoesNotExist()

let s:SID = Sid('autoload/SnippetComplete.vim')
call vimtest#ErrorAndQuitIf(s:SID <= 0, "Failed to determine script's SID")
function! DetermineBaseCol()
    return SidInvoke(s:SID, 'DetermineBaseCol()')
endfunction
function! GetSnippetCompletions()
    return SidInvoke(s:SID, 'GetSnippetCompletions()')
endfunction
