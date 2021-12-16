" KeywordPlusOneComplete.vim: Insert mode completion that completes a sequence of keyword and one non-keyword character.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"
" Copyright: (C) 2021 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_KeywordPlusOneComplete') || (v:version < 700)
    finish
endif
let g:loaded_KeywordPlusOneComplete = 1

"- mappings --------------------------------------------------------------------

inoremap <silent> <expr> <Plug>(KeywordPlusOneComplete) KeywordPlusOneComplete#Expr()
nnoremap <silent> <expr> <SID>(KeywordPlusOneComplete) KeywordPlusOneComplete#Selected()
" Note: Must leave selection first; cannot do that inside the expression mapping
" because the visual selection marks haven't been set there yet.
vnoremap <silent> <script> <Plug>(KeywordPlusOneComplete) <C-\><C-n><SID>(KeywordPlusOneComplete)

if ! hasmapto('<Plug>(KeywordPlusOneComplete)', 'i')
    imap <C-x><C-k> <Plug>(KeywordPlusOneComplete)
endif
if ! hasmapto('<Plug>(KeywordPlusOneComplete)', 'v')
    vmap <C-x><C-k> <Plug>(KeywordPlusOneComplete)
endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
