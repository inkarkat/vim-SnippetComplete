" Test GetAbbreviationCompletions() base columns and relaxed abbreviation matches.
" Tests that (potentially multiple) base columns (depending on the abbreviation
" type) have been identified.
" Tests that for each base column, the union of completion matches for the
" participating abbreviation types have been prepared. The order of completions
" is undefined and isn't tested.

source helpers/SnippetComplete.vim
source helpers/abbreviations.vim

call vimtest#StartTap()
call vimtap#Plan(14)

call IsMatches('$%!', {}, 'no match with empty nonkeyword-delimited base')

call IsMatches('la', {1: ['Cla', 'Clas']}, 'full-id la match at start of line')
call IsMatches('lala la', {6: ['Cla', 'Clas']}, 'full-id cc match space-delimited')
call IsMatches('lala|la', {6: ['Cla', 'Clas']}, 'full-id cc match nonkeyword-delimited')

call IsMatches('norm', {1: ['ccnt', 'ccwo']}, 'expansion norm match at start of line')
call IsMatches('lala norm', {6: ['ccnt', 'ccwo']}, 'expansion norm match space-delimited')
call IsMatches('lala|norm', {6: ['ccnt', 'ccwo']}, 'expansion norm match nonkeyword-delimited')

call IsMatches('o', {1: ['CC', 'Cl', 'ClA', 'Cla', 'Clas', 'Cli', 'ccnt', 'ccwo', 'ccwo', 'coda!', 'coda!', 'pre|ccwo!', 'pre|ccwo!', 'pre|coda!', 'pre|coda!']}, 'full-id expansion and non-id o match at start of line')

call IsMatches('#i', {1: ['##i'], '2': ['##i', '#$%', 'Cl', 'ClA', 'Cla', 'Clas', 'Cli', 'Cli', 'pre|ccnt!', 'pre|ccwo!', 'pre|coda!']}, 'end-id #i match at start of line, OR full-id expansion match')
call IsMatches('#ine', {'2': ['Cl', 'ClA', 'Cla', 'Clas', 'Cli']}, 'expansion match nonkeyword-delimited')
call IsMatches('hash', {1: ['###', '##i', '##x']}, 'expansion hash match at start of line')

call IsMatches('e|', {1: ['pre|ccnt!', 'pre|ccwo!', 'pre|coda!']}, 'non-id e| match at start of line')
call IsMatches('e|cc', {3: ['ccnt', 'ccwo']}, 'full-id e|cc match nonkeyword-delimited')
call IsMatches('e|co', {1: ['pre|coda!'], 3: ['CC', 'Cl', 'ClA', 'Cla', 'Clas', 'Cli', 'coda!', 'pre|coda!']}, 'non-id e|co match at start of line OR non-id co match or expansion co match nonkeyword-delimited')

call vimtest#Quit()
