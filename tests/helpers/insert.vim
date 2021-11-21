" a:idx	    Use -1 to cancel completion, 0 when only one unique match is
"	    expected, 1 for the first match, 2 for the second, etc.
" a:1	    Use a:1'th base.
let g:triggerMapping = "\<C-x>]"
function! Insert( base, idx, ... )
    stopinsert
    let l:keys = 'a' . a:base . repeat(g:triggerMapping, (a:0 ? a:1 : 1)) . repeat("\<C-n>", (a:idx - 1)) . (a:idx == -1 ? "\<C-e>" : '') . (a:idx > 0 ? "\<C-y>" : '') . " \<CR>"
    echomsg l:keys
    execute 'normal' l:keys
endfunction

