# VIM Markify

A simple, lightweight plugin for marking lines using signs for entries in
location list or quickfix lists. Location Lists are given preference over
quickfix lists.

## Change Log

### Version 1.1.1
* Fixed BalloonExpr (<a
  href='https://github.com/dhruvasagar/vim-markify/issues/1'>#1</a>)

### Version 1.1
* Added feature for echoing of message for line under cursor. (borrowed from
  Syntastic). This can be enabled / disabled using the
  `g:markify_echo_current_message` option.

### Version 1.0
* Initial release, core functionality works.

## Getting Started
### Installation

There are 2 ways to do this

1. I recommend installing <a
   href="https://github.com/tpope/vim-pathogen">pathogen.vim</a> and then
   adding a git submodule for your plugin:

```sh
$ cd ~/.vim
$ git submodule add git@github.com:dhruvasagar/vim-markify.git bundle/markify
```

2. Copy plugin/todo-mode.vim, doc/todo-mode.txt to respective ~/.vim/plugin
   and ~/.vim/doc under UNIX or vimfiles/plugin/ and vimfiles/doc under
   WINDOWS and restart VIM

### Usage
   When you have `g:markify_autocmd = 1` (default), then markify is run on
   `QuickFixCmdPost` event and marks the lines with signs automatically.

   Markify can distinguish between errors, warnings &amp; info messages and
   uses different signs for each. By default it uses '>>' to display in the
   signcolumn, however this can be changed.

   If you don't wish to have markify work all the time, you can set
   `g:markify_autocmd = 0` in your $VIMRC. You can call `:Markify` to process
   the current location list or quickfix list ( location lists are given
   preference ) and add the signs. You can call `:MarkifyClear` to clear
   the signs set by Markify and you can also use `:MarkifyToggle` to toggle
   the same.

   Check `:h markify` for more details.

## Contributing

### Reporting an Issue :
   - Use <a href="https://github.com/dhruvasagar/vim-markify/issues">Github
   Issue Tracker</a>

### Contributing to code :
   - Fork it.
   - Commit your changes and give your commit message some love.
   - Push to your fork on github.
   - Open a Pull Request.

## Credits
   I would like to give a shout out to Scroolose for his awesome plugin <a
   href="https://github.com/scrooloose/syntastic">Syntastic</a> which gave me
   the inspiration and know-how to work with signs.

   I would also like to thank Tim Pope for sharing his configurations which
   inspired me to build this plugin.
