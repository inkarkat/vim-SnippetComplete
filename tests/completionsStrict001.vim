" Test GetAbbreviationCompletions() base columns and strict abbreviation matches.
" Tests that (potentially multiple) base columns (depending on the abbreviation
" type) have been identified.
" Tests that for each base column, the union of completion matches for the
" participating abbreviation types have been prepared. The order of completions
" is undefined and isn't tested.

source helpers/SnippetComplete.vim
source helpers/abbreviations.vim

call vimtest#StartTap()
call vimtap#Plan(16)

call IsMatches('', {1: ['###', '##i', '##x', '#$%', 'CC', 'Cl', 'ClA', 'Cla', 'Clas', 'Cli', 'ccnt', 'ccwo', 'coda!', 'pre|ccnt!', 'pre|ccwo!', 'pre|coda!']}, 'all matches at start of line')

call IsMatches('cc', {1: ['ccnt', 'ccwo']}, 'full-id cc match at start of line')
call IsMatches('lala cc', {6: ['ccnt', 'ccwo']}, 'full-id cc match space-delimited')
call IsMatches('lala|cc', {6: ['ccnt', 'ccwo']}, 'full-id cc match nonkeyword-delimited')

call IsMatches('Cl', {1: ['Cl', 'ClA', 'Cla', 'Clas', 'Cli']}, 'full-id Cl match at start of line')
call IsMatches('lala Cl', {6: ['Cl', 'ClA', 'Cla', 'Clas', 'Cli']}, 'full-id Cl match space-delimited')
call IsMatches('lala|Cl', {6: ['Cl', 'ClA', 'Cla', 'Clas', 'Cli']}, 'full-id Cl match nonkeyword-delimited')

call IsMatches('c', {1: ['ccnt', 'ccwo', 'coda!']}, 'full-id and non-id c match at start of line')
call IsMatches('lala c', {6: ['ccnt', 'ccwo', 'coda!']}, 'full-id and non-id c match space-delimited')
call IsMatches('lala|c', {6: ['ccnt', 'ccwo']}, 'full-id c match nonkeyword-delimited')

call IsMatches('##', {1: ['###', '##i', '##x']}, 'end-id + non-id ## match at start of line')
call IsMatches('lala ##', {6: ['###', '##i', '##x']}, 'end-id + non-id ## match space-delimited')
call IsMatches('lalal##', {6: ['##i', '##x']}, 'end-id ## match keyword-delimited')
call IsMatches('#', {1: ['###', '##i', '##x', '#$%']}, 'end-id + non-id # match at start of line')

call IsMatches('pre|', {1: ['pre|ccnt!', 'pre|ccwo!', 'pre|coda!']}, 'non-id pre| match at start of line')
call IsMatches('pre|cc', {1: ['pre|ccnt!', 'pre|ccwo!'], 5: ['ccnt', 'ccwo']}, 'non-id pre|cc match at start of line OR full-id cc match nonkeyword-delimited')

call vimtest#Quit()
