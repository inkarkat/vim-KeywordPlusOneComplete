" Test conversion of non-keyword characters to the one used in the base.

set completefunc=KeywordPlusOneComplete#KeywordPlusOneComplete
call KeywordPlusOneComplete#Expr()    " Initialize script variables.
edit KeywordPlusOneComplete.txt

runtime tests/helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(8)

call IsMatchesInIsolatedLine('me@', ['me@marmelade@moose', 'me@mel@all@we', 'me@most@marvelous@mashup'], 'match for me@ with non-keywords converted to @')
call IsMatchesInIsolatedLine('me&m', ['me&marmelade&moose', 'me&mel&all&we', 'me&most&marvelous&mashup'], 'match for me&m with non-keywords converted to &')
call IsMatchesInIsolatedLine('me%mar', ['me%marmelade%moose'], 'match for me%mar with non-keywords converted to %')
call IsMatchesInIsolatedLine('me#', ['me#marmelade#moose', 'me#mel#all#we', 'me#most#marvelous#mashup'], 'match for me# with non-keywords converted to #')
call IsMatchesInIsolatedLine(',me', [',mel,all,we'], 'match for ,me with non-keywords converted to ,')

call IsMatchesInIsolatedLine('my#scr', ['my#script#31337#path#and#name#without#extension#11'], 'match for my#scr with non-keywords converted to #')
call IsMatchesInIsolatedLine('--quick', ['--quick--'], 'match for --quick with non-keywords converted to -')
call IsMatchesInIsolatedLine('!!quit', ['!!quit!!', '!!quit!!!', '!!quit!for!special!handling', '!!quit!if!one!screen'], 'match for !!quit with non-keywords converted to !')

call vimtest#Quit()
