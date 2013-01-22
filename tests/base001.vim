" Test DetermineBase() for all three types of abbreviations.
" Tests that for the inserted text, the correct base column and abbreviation
" type is detected. (Due to partially entered abbreviations, other types may
" match, too; this is not tested.)
" Tests that the determination differentiates between existing text and text
" that has just been inserted.

source helpers/SnippetComplete.vim

function! s:IsBase( existingText, precedingText, expectedBase, expectedAbbreviationType, description )
    execute 'normal! o' . a:existingText . "\<Esc>"
    execute 'normal! a' . a:precedingText . a:expectedBase . ' '

    let l:expectedBaseCol = strlen(a:existingText) + strlen(a:precedingText) + 1
    call vimtap#collections#contains(DetermineBaseCol(), [[a:expectedAbbreviationType, l:expectedBaseCol]], a:expectedAbbreviationType . ' ' . a:description)
endfunction

call vimtest#StartTap()
call vimtap#Plan(21)

call s:IsBase('', '', 'foo', 'fullid', 'at start of line')
call s:IsBase('', 'lala ', 'foo', 'fullid', 'space-delimited')
call s:IsBase('', "lala\t", 'foo', 'fullid', 'tab-delimited')
call s:IsBase('', 'lala|', 'foo', 'fullid', 'nonkeyword-delimited')
call s:IsBase('', ' a la-la|', '_1', 'fullid', 'complex nonkeyword-delimited')

call s:IsBase('', '', '#i', 'endid', 'at start of line')
call s:IsBase('', 'lala ', '#i', 'endid', 'space-delimited')
call s:IsBase('', "lala\t", '#i', 'endid', 'tab-delimited')
call s:IsBase('', 'lala', '#i', 'endid', 'keyword-delimited')
call s:IsBase('', ' a la-la', '$/7', 'endid', 'complex keyword-delimited')

call s:IsBase('', '', '..', 'endid', 'incomplete at start of line')
call s:IsBase('', 'lala ', '..', 'endid', 'incomplete space-delimited')
call s:IsBase('', "lala\t", '..', 'endid', 'incomplete tab-delimited')
call s:IsBase('', 'lala', '..', 'endid', 'incomplete keyword-delimited')

call s:IsBase('', '', 'def#', 'nonid', 'at start of line')
call s:IsBase('', 'lala ', 'def#', 'nonid', 'space-delimited')
call s:IsBase('', "lala\t", 'def#', 'nonid', 'tab-delimited')
call s:IsBase('', ' a la-la ', '4/7$', 'nonid', 'complex nonkeyword-delimited')

call s:IsBase('lala', '', 'foo', 'fullid', 'at start of insertion')
call s:IsBase('%#^*', '', '#i', 'endid', 'at start of insertion')
call s:IsBase('la %X#ab', '', 'def#', 'nonid', 'at start of insertion')

call vimtest#Quit()
