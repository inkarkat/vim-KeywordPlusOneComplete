KEYWORD PLUS ONE COMPLETE
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

The built-in insert mode completion i\_CTRL-N searches for keywords.
Depending on the 'iskeyword' setting, this can be very fine-grained, so that
fragments like '--quit-if-one-screen' or '/^Vim\\%((\\a\\+)\\)\\=:E123/' can take
many completion commands and are thus tedious to complete.
This plugin offers completion of sequences of non-blank characters (a.k.a.
|WORD|s), i.e. everything separated by whitespace or the start / end of line.
With this, one can quickly complete entire text fragments which are delimited
by whitespace.

### SEE ALSO

- Check out the CompleteHelper.vim plugin page ([vimscript #3914](http://www.vim.org/scripts/script.php?script_id=3914)) for a full
  list of insert mode completions powered by it.

USAGE
------------------------------------------------------------------------------

    In insert mode, invoke the keyword plus one completion via CTRL-X CTRL-K.
    You can then search forward and backward via CTRL-N / CTRL-P, as usual.

    CTRL-X CTRL-K           Find matches from a base of keyword characters and one
                            particular non-keyword non-whitespace character in
                            front of the cursor; each match consists of keyword
                            characters and one particular non-keyword
                            non-whitespace character - not necessarily the one
                            that's contained in the base, but other characters are
                            converted into the non-keyword character from the
                            base.
                            First, a match will only start at the beginning of a
                            word or with a non-keyword character; if that returns
                            no results, matches within keywords will also be
                            considered.
                            Further use of CTRL-X CTRL-K will copy the text
                            including the next such text following the previous
                            expansion in other contexts.

    {Visual}CTRL-X CTRL-K   Find matches for text that starts with the selected
                            text where any non-keyword character (also whitespace)
                            stands for any non-keyword non-whitespace character
                            match, but all matching the same character; the full
                            match then consists of keyword characters and that one
                            particular non-keyword non-whitespace character. If
                            the selected text has just one unique non-keyword
                            non-whitespace character, other characters in the
                            matches are converted to that; else, the match is
                            offered verbatim.

### EXAMPLE

To query a command argument when it's only documented in square braces so far
([--foo-bar]; "-" is not part of 'iskeyword' here), just type "--f" and
trigger the completion to --foo-bar; the surrounding non-keyword "[" and "]"
will not be part of the match because "-" is taken as the one non-keyword
non-whitespace character.
Likewise, to complete the command argument when its use is inside quotes, type
"'--f" and trigger the completion to --foo-bar; the completion base will just
consider the "-"s but stop before the "'".

If there's a text "my@special@identifier" already and you want to complete it
with the "@" converted into "-", type "my-" and trigger the completion;
my-special-identifier will be offered.

With the relaxed search, "foo#" will complete the entire "foo#bar"
found in "snafoo#bar".

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-KeywordPlusOneComplete
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim KeywordPlusOneComplete*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.010 or
  higher.
- Requires the CompleteHelper.vim plugin ([vimscript #3914](http://www.vim.org/scripts/script.php?script_id=3914)), version 1.40 or
  higher.

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

By default, the 'complete' option controls which buffers will be scanned for
completion candidates. You can override that either for the entire plugin, or
only for particular buffers; see CompleteHelper\_complete for supported
values.

    let g:KeywordPlusOneComplete_complete = '.,w,b,u'

If you want to use a different mapping, map your keys to the
&lt;Plug&gt;(KeywordPlusOneComplete) mapping target _before_ sourcing the script (e.g.
in your vimrc):

    imap <C-x><C-k> <Plug>(KeywordPlusOneComplete)
    vmap <C-x><C-k> <Plug>(KeywordPlusOneComplete)

CONTRIBUTING
------------------------------------------------------------------------------

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-KeywordPlusOneComplete/issues or email
(address below).

HISTORY
------------------------------------------------------------------------------

##### 0.01    16-Dec-2021
- Started development based on WORDComplete.vim.

------------------------------------------------------------------------------
Copyright: (C) 2021 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
