" Test RetrieveAbbreviations() buffer-local override of global abbreviation.
" Tests that the buffer-local abbreviation always overrides the global one, no
" matter which is defined first.
" Test that other abbreviations are not affected by the pruning of local
" overrides.

call vimtest#StartTap()
call vimtap#Plan(6)

ia FOO FOObar
ia <buffer> FOO local FOObar
let s:actualMatches = SnippetComplete#Abbreviations#RetrieveAbbreviations()
call vimtap#Is(len(s:actualMatches), 1, 'Only one (local) match')
call vimtap#Is(s:actualMatches[0].word, 'FOO', 'FOO match is lhs')
call vimtap#Is(s:actualMatches[0].menu, 'local FOObar', 'local rhs')

ia Bystander1 innocent bystander
ia <buffer> BAR local BARbar
ia BAR BARbar
ia <buffer> Bystander2 innocent local bystander
let s:actualMatches = SnippetComplete#Abbreviations#RetrieveAbbreviations()
call vimtap#Is(len(s:actualMatches), 4, '2 local matches and 2 bystanders')

call vimtap#collections#contains(map(copy(s:actualMatches), 'v:val.word'), 'BAR', 'BAR match is lhs')
call vimtap#collections#contains(map(copy(s:actualMatches), 'v:val.menu'), 'local BARbar', 'local rhs')

call vimtest#Quit()
