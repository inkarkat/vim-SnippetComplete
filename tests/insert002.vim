" Test impossible insertion of abbreviations. 

source helpers/abbreviations.vim
source helpers/insert.vim

call Insert('full-id none: Ccn', 0)

call Insert('end-id non: lala|$', 0)
call Insert('end-id non: lala#$', 0)

call Insert('end-id/non-id none: ##X', 0)

call Insert('non-id none: $$$', 0)
call Insert('non-id none: pre|XX', 0)

call vimtest#SaveOut()
call vimtest#Quit()

