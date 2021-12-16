" Test relaxed completion of keyword and one non-keyword characters.

set completefunc=KeywordPlusOneComplete#KeywordPlusOneComplete
call KeywordPlusOneComplete#Expr()    " Initialize script variables.
edit KeywordPlusOneComplete.txt

runtime tests/helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(5)
call IsMatchesInIsolatedLine('cra', ['crazy:name'], 'relaxed match for cra')
call IsMatchesInIsolatedLine('scor', ['score:code:name', 'score:code:negative'], 'relaxed matches for scor')
call IsMatchesInIsolatedLine('-spec', ['-special-handling'], 'relaxed match for -spec')
call IsMatchesInIsolatedLine(':code:na', [':code:name'], 'relaxed matches for :code:na')
call IsMatchesInIsolatedLine('&all', ['&all&we'], 'relaxed matches for &all')
call vimtest#Quit()
