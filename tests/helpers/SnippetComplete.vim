runtime plugin/SidTools.vim

let s:SID = Sid('plugin/SnippetComplete.vim')
function! GetAbbreviations()
    return SidInvoke(s:SID, 'GetAbbreviations()')
endfunction
function! DetermineBaseCol()
    return SidInvoke(s:SID, 'DetermineBaseCol()')
endfunction
function! GetAbbreviationCompletions()
    return SidInvoke(s:SID, 'GetAbbreviationCompletions()')
endfunction
