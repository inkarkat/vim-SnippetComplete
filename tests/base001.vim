" Test DetermineBase() for all three types of abbreviations. 

source helpers/abbreviations.vim

function! s:IsBase( existingText, precedingText, expectedBase, description )
    1delete _
    execute 'normal! a' . a:existingText . "\<Esc>"
    execute 'normal! a' . a:precedingText . a:expectedBase . ' '

    let l:expectedBaseCol = strlen(a:existingText) + strlen(a:precedingText) + 1
    call vimtap#Is(DetermineBaseCol(), l:expectedBaseCol, a:description)
endfunction

call vimtest#StartTap()
call vimtap#Plan(21)

call s:IsBase('', '', 'foo', 'full-id at start of line')
call s:IsBase('', 'lala ', 'foo', 'full-id space-delimited')
call s:IsBase('', "lala\t", 'foo', 'full-id tab-delimited')
call s:IsBase('', 'lala|', 'foo', 'full-id nonkeyword-delimited')
call s:IsBase('', ' a la-la|', '_1', 'full-id complex nonkeyword-delimited')

call s:IsBase('', '', '#i', 'end-id at start of line')
call s:IsBase('', 'lala ', '#i', 'end-id space-delimited')
call s:IsBase('', "lala\t", '#i', 'end-id tab-delimited')
call s:IsBase('', 'lala', '#i', 'end-id keyword-delimited')
call s:IsBase('', ' a la-la', '$/7', 'end-id complex keyword-delimited')

call s:IsBase('', '', '..', 'incomplete end-id at start of line')
call s:IsBase('', 'lala ', '..', 'incomplete end-id space-delimited')
call s:IsBase('', "lala\t", '..', 'incomplete end-id tab-delimited')
if ! vimtap#Skip(1, 0, 'Cannot distinguish incomplete end-id keyword-delimited from non-id')
    call s:IsBase('', 'lala', '..', 'incomplete end-id keyword-delimited')
endif

call s:IsBase('', '', 'def#', 'non-id at start of line')
call s:IsBase('', 'lala ', 'def#', 'non-id space-delimited')
call s:IsBase('', "lala\t", 'def#', 'non-id tab-delimited')
call s:IsBase('', ' a la-la ', '4/7$', 'non-id complex nonkeyword-delimited')

call s:IsBase('lala', '', 'foo', 'full-id at start of insertion')
call s:IsBase('%#^*', '', '#i', 'end-id at start of insertion')
call s:IsBase('la %X#ab', '', 'def#', 'non-id at start of insertion')


call vimtest#Quit()

