" Test straightforward insertion of abbreviations.

source helpers/abbreviations.vim
source helpers/insert.vim

call Insert('full-id unique: ccn', 0)
call Insert('full-id unique:|ccw', 0)
call Insert('full-id unique:|ccnt', 0)

call Insert('full-id alternatives: cc', 1)
call Insert('full-id alternatives: cc', 2)
call Insert('full-id alternatives:|C', 6)

call Insert('end-id unique: lala##i', 0)
call Insert('end-id alternative: lala##', 2)

call Insert('end-id/non-id alternative: ##', 2)
call Insert('end-id/non-id alternative: ##', 1)
call Insert('end-id/non-id alternative: #', 4)

call Insert('non-id unique: #$', 0)
call Insert('non-id unique: co', 0)
call Insert('non-id unique: pre|co', 0)
call Insert('non-id alternative: pre|', 2)

call vimtest#SaveOut()
call vimtest#Quit()
