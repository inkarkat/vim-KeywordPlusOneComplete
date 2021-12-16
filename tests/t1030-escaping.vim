" Test replacement escaping in completion of keyword and one non-keyword characters.

set completefunc=KeywordPlusOneComplete#KeywordPlusOneComplete
call KeywordPlusOneComplete#Expr()    " Initialize script variables.
edit KeywordPlusOneComplete.txt

runtime tests/helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(4)
call IsMatchesInIsolatedLine('/sla', ['/slashed/here/'], 'match for /sla')
call IsMatchesInIsolatedLine('not\', ['not\backslashed\there\'], 'match for not\\')
call IsMatchesInIsolatedLine('\sla', ['\slashed\here\'], 'match for \sla with non-keywords converted to \\')
call IsMatchesInIsolatedLine('not/', ['not/backslashed/there/'], 'match for not/ with non-keywords converted to /')
call vimtest#Quit()
