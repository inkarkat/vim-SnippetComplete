" Test RetrieveAbbreviations() retrieval of defined abbreviations in insert mode.
" Tests that insert-mode and any-mode abbreviations, global and buffer-local
" ones are retrieved.
" Does not impose any ordering of the retrieved abbreviations.

call vimtest#StartTap()
call vimtap#Plan(13)

function! s:IsWords( which, expectedWords, description )
    let l:actualMatches = SnippetComplete#Abbreviations#RetrieveAbbreviations(a:which)
    call vimtap#collections#IsSet(map(l:actualMatches, 'v:val.word'), a:expectedWords, a:description)
endfunction

call s:IsWords('all', [], 'No abbreviations')
call s:IsWords('global', [], 'No global abbreviations')
call s:IsWords('local', [], 'No local abbreviations')

ab FOO FOObar
call s:IsWords('all', ['FOO'], 'FOO any-mode abbreviation')
call s:IsWords('global', ['FOO'], 'FOO any-mode global abbreviation')
call s:IsWords('local', [], 'No local FOO abbreviation')

ab Foo Foobar
call s:IsWords('all', ['FOO', 'Foo'], 'FOO+Foo any-mode abbreviations')
call s:IsWords('global', ['FOO', 'Foo'], 'FOO+Foo any-mode global abbreviations')
call s:IsWords('local', [], 'No local FOO+Foo any-mode abbreviations')

ia AAA Triple-A
ia ZZZ Triple-Z
ia XXX Triple-X
call s:IsWords('all', ['AAA', 'FOO', 'Foo', 'XXX', 'ZZZ'], 'Foo and Triple abbreviations')

ia <buffer> Buffer (this local buffer only)
ia <buffer> Puffer (this local buffer only)
call s:IsWords('all', ['AAA', 'Buffer', 'FOO', 'Foo', 'Puffer', 'XXX', 'ZZZ'], 'Foo, Triple and B/Puffer abbreviations')
call s:IsWords('global', ['AAA', 'FOO', 'Foo', 'XXX', 'ZZZ'], 'Foo, Triple global abbreviations')
call s:IsWords('local', ['Buffer', 'Puffer'], 'B/Puffer local abbreviations')

call vimtest#Quit()
