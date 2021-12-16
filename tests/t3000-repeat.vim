" Test repeat of KeywordPlusOne completion.

runtime tests/helpers/insert.vim
view KeywordPlusOneComplete.txt
new

call SetCompletion("\<C-x>\<C-k>")
call SetCompleteExpr('KeywordPlusOneComplete#Expr')

call InsertRepeat('foo --quit', 1, 0, 0)
call InsertRepeat('fox --excl', 0, 0, 0, 0, 0, 0, 0, 0)
call InsertRepeat('ship:', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)

call vimtest#SaveOut()
call vimtest#Quit()
