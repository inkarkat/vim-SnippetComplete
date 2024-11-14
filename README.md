SNIPPET COMPLETE
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

Insert mode abbreviations and snippets can dramatically speed up editing, but
how does one remember all those shortcuts that are rarely used? You can list
all insert mode abbreviations via :ia to break out of this vicious circle,
but switching to command mode for that is cumbersome.

This plugin offers a context-sensitive insert mode completion to quickly list
and complete defined abbreviations directly while typing.

### SEE ALSO

- The SnippetCompleteSnipMate.vim plugin ([vimscript #4276](http://www.vim.org/scripts/script.php?script_id=4276)) extends the
  completion with snippets for the popular snipMate plugin ([vimscript #2540](http://www.vim.org/scripts/script.php?script_id=2540)).

USAGE
------------------------------------------------------------------------------

    In insert mode, optionally type part of the snippet shortcut or a fragment
    from its expected expansion, and invoke the snippet completion via CTRL-X ].
    You can then search forward and backward via CTRL-N / CTRL-P, as usual.

    CTRL-X ]                Find matches for abbreviations that start with the
                            text in front of the cursor. If other snippet types
                            are registered, show those, too.
                            If no matches were found that way, matches anywhere in
                            the snippet or in the snippet's expanded text will be
                            shown. So if you can't remember the shortcut, but a
                            word fragment from the resulting expansion, just try
                            with that.

                            There are three types of abbreviations (full-id,
                            end-id and non-id), which can consist of different
                            characters. Thus, there can be more than one candidate
                            for the existing completion base, e.g. "pre@c" can
                            expand into a full-id abbreviation starting with "c"
                            or into a non-id one starting with "pre@c". The
                            completion indicates such a ambiguity through the
                            message "base n of m; next: blah", and you can cycle
                            through the different completion bases by repeating
                            the i_CTRL-X_] shortcut.

                            Matches are selected and inserted as with any other
                            ins-completion, see popupmenu-keys. If you use
                            <Space> or i_CTRL-] to select an abbreviation, it'll
                            be expanded automatically.

    CTRL-X g]               Find matches for buffer-local abbreviations that start
                            with the text in front of the cursor. If other snippet
                            types are registered, show those (local ones), too.

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-SnippetComplete
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim SnippetComplete*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the CompleteHelper.vim plugin ([vimscript #3914](http://www.vim.org/scripts/script.php?script_id=3914)), version 1.10 or
  higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.020 or
  higher.

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

If you want to use a different mapping, map your keys to the
&lt;Plug&gt;(SnippetComplete...) mapping targets _before_ sourcing the script (e.g.
in your vimrc).
For example, to use CTRL-X [g] &lt;Tab&gt; as the completion trigger, define this:

    imap <C-x><Tab>  <Plug>(SnippetComplete)
    imap <C-x>g<Tab> <Plug>(SnippetCompleteLocal)

The plugin also provides additional mappings that ignore any added snippets
types in g:SnippetComplete\_RegisteredTypes and instead just show
abbreviations. You can add mappings to these if you need to distinguish
between both:

    imap <C-x>[ <Plug>(SnippetCompleteAbbr)
    imap <C-x>g[ <Plug>(SnippetCompleteLocalAbbr)

INTEGRATION
------------------------------------------------------------------------------

There exist multiple snippet systems that extend the built-in abbreviations
with support for filetype-specific and more complex expansions, like allowing
placeholders and expansion of in-line scriptlets. One popular one is the
snipMate plugin ([vimscript #2540](http://www.vim.org/scripts/script.php?script_id=2540)).
Since there is a seamless transition from simple abbreviation to complex
snippet, it may help to have a completion for both sources. To support this,
this plugin allows to write completions for other snippet plugins with just a
little bit of configuration and a function to retrieve the valid snippets.
This completion can be stand-alone via a different mapping, or it can add the
snippets to the i\_CTRL-X\_] completion mapping provided here.

The definition of a snippet type consists of an object with the following
properties:

    let typeDefinition = {
    \   '{typeName}': {
    \       'priority': 100,
    \       'pattern': '\k\+',
    \       'generator': function('MySnippets#Get')
    \   }
    \}

The {pattern} key specifies the valid syntax of the snippets; the {generator}
should return all snippets in the format of complete-items; the filtering
according to the completion base is done by this plugin itself.

To include the snippets in the i\_CTRL-X\_] completion mapping provided here:

    call extend(g:SnippetComplete_RegisteredTypes, typeDefinition)

To create a separate completion mapping for your type:

    inoremap <silent> <C-x>% <C-r>=SnippetComplete#PreSnippetCompleteExpr()<CR><C-r>=SnippetComplete#SnippetComplete(typeDefinition)<CR>

Like g:SnippetComplete\_RegisteredTypes, but to include (preferably only
local) snippets in the i\_CTRL-X\_g] completion mapping for buffer-local
abbreviations.

KNOWN PROBLEMS
------------------------------------------------------------------------------

- When &lt;CR&gt; is :map-expr to &lt;C-Y&gt; when pumvisible() to accept the current
  entry, and there's additional processing after &lt;C-Y&gt; (in my case, &lt;C-\\&gt;&lt;C-o&gt;
  to call a function) the completed abbreviation is not expanded any more.

### TODO

- Getting and sorting of matches when 'ignorecase' is on.

### CONTRIBUTING

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-SnippetComplete/issues or email (address
below).

HISTORY
------------------------------------------------------------------------------

##### 2.21    14-Nov-2024
- ENH: Add (unmapped by default) &lt;Plug&gt;-mappings for just [local]
  abbreviations; this can be useful if there are both many snippets and
  abbreviations.

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.020!__

##### 2.20    03-Apr-2014
- ENH: Add CTRL-X g] mapping variant that limits the results to buffer-local
  abbreviations. This is useful to quickly get an overview of
  filetype-specific abbreviations, which are usually drowned in the sea of
  global ones (and snippets if integrated).
- Add dependency to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)).

__You need to separately
  install ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.009 (or higher)!__

##### 2.11    15-Jan-2013
- FIX: Must use numerical sort() for s:lastCompletionsByBaseCol.

##### 2.10    19-Oct-2012
- ENH: When no base doesn't match with the beginning of a snippet, fall back
  to matches either anywhere in the snippet or in the snippet expansion.
- Truncate very long or multi-line snippet expansions in the popup menu. This
  requires the CompleteHelper plugin. When the entire snippet doesn't fit into
  the popup menu, offer it for showing in the preview window.

__THIS PLUGIN NOW REQUIRES THE CompleteHelper PLUGIN ([vimscript #3914](http://www.vim.org/scripts/script.php?script_id=3914))__

##### 2.01    13-Aug-2012
- FIX: Vim 7.0/1 need preloading of functions referenced in Funcrefs.

##### 2.00    08-May-2012
- Modularize and generalize for completing other types of snippets (e.g. from
  snipMate).

##### 1.01    25-Sep-2010
- Using separate autoload script to help speed up Vim startup.

##### 1.00    12-Jan-2010
- First published version.

##### 0.01    08-Jan-2010
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2010-2024 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
