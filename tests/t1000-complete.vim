" Test completion of keyword and one non-keyword characters.

set completefunc=KeywordPlusOneComplete#KeywordPlusOneComplete
call KeywordPlusOneComplete#Expr()    " Initialize script variables.
edit KeywordPlusOneComplete.txt

runtime tests/helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(10)
call IsMatchesInIsolatedLine('doesnotexist', [], 'no matches for doesnotexist')
call IsMatchesInIsolatedLine('sh', ['ship-me'], 'match for sh')
call IsMatchesInIsolatedLine('underscore', ['underscore:code:negative'], 'match for underscore')
call IsMatchesInIsolatedLine('pre', ['prefixed:bad:code:name', 'prefixed:this:crazy:name', 'prefixed:underscore:code:name'], 'matches for pre')
call IsMatchesInIsolatedLine('--quit', ['--quit-for-special-handling', '--quit-if-one-screen', '--quit--', '--quit---'], 'matches for --quit')
call IsMatchesInIsolatedLine('--quit-', ['--quit-for-special-handling', '--quit-if-one-screen', '--quit--', '--quit---'], 'matches for --quit-')
call IsMatchesInIsolatedLine('--quit--', ['--quit---'], 'matches for --quit--')
call IsMatchesInIsolatedLine('--quie', ['--quiet-errors', '--quiet-info', '--quiet-stuff', '--quiet--'], 'matches for --quie')
call IsMatchesInIsolatedLine('my-', ['my-script-31337-path-and-name-without-extension-11'], 'match for my-')
call IsMatchesInIsolatedLine('me', ['me@marmelade@moose', 'me&mel&all&we', 'me%most%marvelous%mashup'], 'match for me')
call vimtest#Quit()
