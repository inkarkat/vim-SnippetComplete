" Test detection of repeat completion on completion end change.
" Tests the effect of s:PreSnippetCompleteExpr().

source helpers/abbreviations.vim

ia ccverylongabb normal very long abbreviation

set completeopt=menu,longest
execute "normal apre|c\<C-x>]\<C-n>\<C-x>]\<C-y> \<CR>"
set completeopt=longest
execute "normal apre|c\<C-x>]\<C-n>\<C-x>]\<C-y> \<CR>"

call vimtest#SaveOut()
call vimtest#Quit()
