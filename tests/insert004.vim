" Test use of alternative completion bases for abbreviations.

source helpers/abbreviations.vim
source helpers/insert.vim

" XXX: Somehow, when no completion menu is shown, the automation doesn't expand
" the completed abbreviation; when executed manually, it works, though.
" Inserting a temporary line somehow helps?! (Vim 7.2.000, Windows Vista x86.)
function! s:Insert( base, idx, baseIdx )
    execute "normal! aXXX\<CR>"
    call Insert(a:base, a:idx, a:baseIdx)
endfunction

let s:isFirst = 1
for s:completeopt in ([&completeopt, '', 'longest', 'menu', 'menuone', 'longest,menuone'])
    execute 'set completeopt=' . s:completeopt
    if ! s:isFirst
	" Do not echo the first, preconfigured option value, as it depends on
	" the individual configuration.
	execute 'normal! oset completeopt=' . &completeopt . "\<CR>"
    endif
    let s:isFirst = 0
    echo 'First base.'
    call s:Insert('pre|cc', 2, 1)
    echo 'Second base.'
    call s:Insert('pre|cc', 2, 2)
    echo 'Cycling through to first base.'
    call s:Insert('pre|cc', 2, 3)
    echo 'Unique match, second base.'
    call s:Insert('pre|ccn', 0, 2)
endfor

" XXX: See above.
%g/^XXX/d

call vimtest#SaveOut()
call vimtest#Quit()
