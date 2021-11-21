" Test insertion of buffer-local abbreviations.

source helpers/abbreviations.vim
source helpers/insert.vim

ia <buffer> ccnt local ccnt
ia <buffer> cclo local cclo

call Insert('full-id unique local: ccl', 0)
call Insert('full-id unique local overrides global: ccn', 0)
call Insert('full-id unique global: ccw', 0)

call Insert('full-id alternatives: cc', 1)
call Insert('full-id alternatives: cc', 2)
call Insert('full-id alternatives: cc', 3)

let g:triggerMapping = "\<C-x>g]"

call Insert('local full-id unique local: ccl', 0)
call Insert('local full-id unique local overrides global: ccn', 0)
call Insert('local full-id unique no global: ccw', 0)

let g:triggerMapping = "\<C-x>]"
call Insert('full-id unique global: ccw', 0)

call vimtest#SaveOut()
call vimtest#Quit()
