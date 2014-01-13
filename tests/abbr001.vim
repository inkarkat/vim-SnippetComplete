" Test RetrieveAbbreviations() retrieval of defined abbreviations in insert mode.
" Tests that insert-mode and any-mode abbreviations, global and buffer-local
" ones are retrieved.
" Does not impose any ordering of the retrieved abbreviations.

call vimtest#StartTap()
call vimtap#Plan(5)

function! s:IsWords( expectedWords, description )
    let l:actualMatches = SnippetComplete#Abbreviations#RetrieveAbbreviations()
    call vimtap#collections#IsSet(map(l:actualMatches, 'v:val.word'), a:expectedWords, a:description)
endfunction

call s:IsWords([], 'No abbreviations')

ab FOO FOObar
call s:IsWords(['FOO'], 'FOO any-mode abbreviation')

ab Foo Foobar
call s:IsWords(['FOO', 'Foo'], 'FOO+Foo any-mode abbreviations')

ia AAA Triple-A
ia ZZZ Triple-Z
ia XXX Triple-X
call s:IsWords(['AAA', 'FOO', 'Foo', 'XXX', 'ZZZ'], 'Foo and Triple abbreviations')

ia <buffer> Buffer (this local buffer only)
ia <buffer> Puffer (this local buffer only)
call s:IsWords(['AAA', 'Buffer', 'FOO', 'Foo', 'Puffer', 'XXX', 'ZZZ'], 'Foo, Triple and Buffer abbreviations')

call vimtest#Quit()
