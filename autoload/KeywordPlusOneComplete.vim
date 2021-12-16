" KeywordPlusOneComplete.vim: Insert mode completion that completes a sequence of keyword and one non-keyword character.
"
" DEPENDENCIES:
"   - CompleteHelper.vim plugin
"   - ingo-library.vim plugin
"
" Copyright: (C) 2021 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

function! s:GetCompleteOption()
    return ingo#plugin#setting#GetBufferLocal('KeywordPlusOneComplete_complete', &complete)
endfunction

function! KeywordPlusOneComplete#ReplaceWithUniqueNonKeywordCharacter( matchText ) abort
    return substitute(a:matchText, '\k\@!.', escape(s:uniqueNonKeywordCharacter, '\&'), 'g')
endfunction

function! s:ToSameNonKeywordMatch( match, firstNonKeywordAssertion ) abort
    let s:matchCount += 1
    return (s:matchCount == 1 ? '\(\k\@!\S\)' . a:firstNonKeywordAssertion : '\1')
endfunction
function! s:GetAllNonKeywordBasePattern( base, firstNonKeywordAssertion ) abort
    let l:escapedBase = escape(a:base, '\')
    " First non-keyword captures the particular character.
    " Any subsequent non-keywords assert the same character.
    let s:matchCount = 0
    let l:allNonKeywordBasePattern = substitute(l:escapedBase, '\\\\\|\%(\k\@!.\)', '\=s:ToSameNonKeywordMatch(submatch(0), a:firstNonKeywordAssertion)', 'g')
    if l:allNonKeywordBasePattern ==# l:escapedBase
	let l:allNonKeywordBasePattern = l:escapedBase . '\k\*\(\k\@!\S\)' . a:firstNonKeywordAssertion    " Base does not contain a non-keyword character; capture at least one.
    endif
    return l:allNonKeywordBasePattern
endfunction

let s:repeatCnt = 0
function! KeywordPlusOneComplete#KeywordPlusOneComplete( findstart, base )
    if s:repeatCnt
	if a:findstart
	    return col('.') - 1
	else
	    let l:matches = []

	    " Need to translate the embedded ^@ newline into the \n atom.
	    let l:previousCompleteExpr = substitute(escape(s:fullText, '\'), '\n', '\\n', 'g')
	    " Undo the potential conversion of non-keyword characters into the
	    " unique one (to relocate the previous match).
	    let l:previousAnyNonKeywordCompleteExpr = substitute(l:previousCompleteExpr, '\\\\\|\%(\k\@!.\)', '\\k\\@!\\.', 'g')

	    let l:uniqueNonKeywordCharacterAtom = escape(matchstr(s:fullText, '\k\@!\S'), '\')

	    " The previous completion ends either in the unique non-keyword
	    " character or a keyword. The next chunk again ends with either of
	    " those.
	    let l:repeatPattern =
	    \	'\V' . l:previousAnyNonKeywordCompleteExpr . '\zs' .
	    \   '\_s\*\%(\k\@!\s\@!' . l:uniqueNonKeywordCharacterAtom . '\@!\.\)\*\' .
	    \   '%(\k\+\' . l:uniqueNonKeywordCharacterAtom . '\*\|' . l:uniqueNonKeywordCharacterAtom . '\+\k\*\)'

	    call CompleteHelper#FindMatches(l:matches,
	    \   l:repeatPattern,
	    \	{'complete': s:GetCompleteOption(), 'processor': function('CompleteHelper#Repeat#Processor')}
	    \)
	    if empty(l:matches)
		call CompleteHelper#Repeat#Clear()
	    endif
	    return l:matches
	endif
    endif

    if a:findstart
	if s:selectedBaseCol
	    return s:selectedBaseCol - 1    " Return byte index, not column.
	else
	    " Locate the start of the keyword plus one.
	    let l:startCol = searchpos('\k*\(\S\)\%(\k*\1\)*\k*\%#', 'bn', line('.'))[1]
	    if l:startCol == 0
		let l:startCol = col('.')
	    endif
	    return l:startCol - 1 " Return byte index, not column.
	endif
    else
	let l:allNonKeywordBasePattern = s:GetAllNonKeywordBasePattern(a:base, '\%(\1\k\*\1\)\@<!')
	let s:uniqueNonKeywordCharacter = matchstr(a:base, '^\k*\zs\(\k\@!\S\)\ze\%(\k*\1\)*\k*$')   " If there's one unique non-keyword non-whitespace character in the base, replace any non-keyword characters in the matches with it.
	let l:baseStartAssertion = (a:base =~# '^\k' ? '\<' : '')

	let l:options = {'complete': s:GetCompleteOption()}
	if ! empty(s:uniqueNonKeywordCharacter)
	    let l:options.processor = function('KeywordPlusOneComplete#ReplaceWithUniqueNonKeywordCharacter')
	endif

	" Find matches starting with a:base and ending with whitespace or the
	" end of the line. The match must start at the beginning of the line or
	" after whitespace.
	let l:matches = []
	call CompleteHelper#FindMatches(l:matches, '\V' . l:baseStartAssertion . l:allNonKeywordBasePattern . '\%(\k\|\1\)\+', l:options)
	if empty(l:matches)
	    let l:allNonKeywordBasePattern = s:GetAllNonKeywordBasePattern(a:base, '')
	    " In case there are no matches, relax the restriction that the base
	    " that starts with a keyword character is anchored to the beginning
	    " of a keyword.
	    echohl ModeMsg
	    echo '-- User defined completion (^U^N^P) -- Relaxed search...'
	    echohl None
	    call CompleteHelper#FindMatches(l:matches, '\V' . l:allNonKeywordBasePattern . '\%(\k\|\1\)\+', l:options)
	endif
	return l:matches
    endif
endfunction

function! KeywordPlusOneComplete#Expr()
    let s:selectedBaseCol = 0
    set completefunc=KeywordPlusOneComplete#KeywordPlusOneComplete

    let s:repeatCnt = 0 " Important!
    let [s:repeatCnt, l:addedText, s:fullText] = CompleteHelper#Repeat#TestForRepeat()
"****D echomsg '****' string([s:repeatCnt, l:addedText, s:fullText])
    return "\<C-x>\<C-u>"
endfunction

function! KeywordPlusOneComplete#Selected()
    call KeywordPlusOneComplete#Expr()
    let s:selectedBaseCol = col("'<")

    return 'g`>' . (col("'>") == (col('$')) ? 'a' : 'i') . "\<C-x>\<C-u>"
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
