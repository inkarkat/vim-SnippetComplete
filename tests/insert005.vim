" Test detection of repeat completion on completion end change.
" Tests the effect of s:PreSnippetCompleteExpr().

call vimtest#SkipAndQuitIf(v:version < 900 || v:version == 900 && ! has('patch567'), 'Need complete() support for completeopt=longest')
source helpers/abbreviations.vim

ia ccverylongabb normal very long abbreviation

set completeopt=menu,longest
execute "normal apre|c\<C-x>]\<C-n>\<C-n>\<C-x>]\<C-n>\<C-y> \<CR>"
set completeopt=longest
execute "normal apre|c\<C-x>]\<C-n>\<C-n>\<C-x>]\<C-n>\<C-y> \<CR>"

call vimtest#SaveOut()
call vimtest#Quit()
