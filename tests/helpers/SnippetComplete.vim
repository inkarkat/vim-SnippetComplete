runtime plugin/SidTools.vim
runtime autoload/SnippetComplete.vim

let s:SID = Sid('autoload/SnippetComplete.vim')
call vimtest#ErrorAndQuitIf(s:SID <= 0, "Failed to determine script's SID")
function! GetAbbreviations()
    return SidInvoke(s:SID, 'GetAbbreviations()')
endfunction
function! DetermineBaseCol()
    return SidInvoke(s:SID, 'DetermineBaseCol()')
endfunction
function! GetAbbreviationCompletions()
    return SidInvoke(s:SID, 'GetAbbreviationCompletions()')
endfunction
