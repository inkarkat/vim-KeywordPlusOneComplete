" Test completion from selected base.

set completefunc=KeywordPlusOneComplete#KeywordPlusOneComplete
call KeywordPlusOneComplete#Expr()    " Initialize script variables.
let g:SelectBase = 'call KeywordPlusOneComplete#Selected()'
edit KeywordPlusOneComplete.txt

runtime tests/helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(11)

call IsMatchesInContext('prefixed:', '', 'doesNotExist', [], 'no matches for doesNotExist')
call IsMatchesInContext('eval "', '', '--incl', ['--include'], 'match for selected --incl')
call IsMatchesInContext('-', '', '--quit-', ['--quit-for-special-handling', '--quit-if-one-screen', '--quit--', '--quit---'], 'matches for selected --quit-')
call IsMatchesInContext('-', '', '-excl', ['-exclude'], 'match for selected -excl')
call IsMatchesInContext('Query', '', 'Matches', ['MatchesInCurrentWindow(match', 'MatchesInOtherWindows(matches'], 'matches for Matches')

call IsMatchesInContext('', '', '$%no', ['--not'], 'match for selected $%no')
call IsMatchesInContext('', '', '  no', ['--not'], 'match for selected <Space><Space>no')
call IsMatchesInContext(',,', '', ',me', [',mel,all,we'], 'match for selected ,me')

call IsMatchesInContext('', '', '  quit ', ['**quit**', ',,quit,,,', '--quit-for-special-handling', '--quit-if-one-screen'], 'match for selected <Space><Space>quit<Space>')
call IsMatchesInContext('', '', '- quit ', ['**quit**', ',,quit,,,', '--quit-for-special-handling', '--quit-if-one-screen'], 'match for selected -<Space>quit<Space>')
call IsMatchesInContext('', '', '  quiet ', ['**quiet**', '--quiet-errors', '--quiet-info', '--quiet-stuff'], 'match for selected <Space><Space>quiet<Space>')

call vimtest#SaveOut()
call vimtest#Quit()
