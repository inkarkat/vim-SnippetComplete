" Test insertion of abbreviations that depend on start-of-insert.
" Tests that the start-of-insert position is captured correctly and considered
" when matching abbrevations with the determined base.

source helpers/abbreviations.vim
source helpers/insert.vim

function! InsertAfterPrevious( previous, base, idx )
    execute 'normal! a' . a:previous
    call Insert(a:base, a:idx)
endfunction

call InsertAfterPrevious('full-id unique with previous', 'ccn', 0)
call InsertAfterPrevious('full-id alternatives with previous', 'cc', 2)

call InsertAfterPrevious('end-id unique: $$$', '##i', 0)

call InsertAfterPrevious('end-id/non-id alternative: $$$','##', 2)

call InsertAfterPrevious('non-id unique: $$$', '#$', 0)
call InsertAfterPrevious('non-id unique: $$$', 'co', 0)
call InsertAfterPrevious('non-id unique: previous', 'pre|ccn', 0)
call InsertAfterPrevious('non-id alternative: previous', 'pre|cc', 2)

call vimtest#SaveOut()
call vimtest#Quit()
