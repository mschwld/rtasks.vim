# About rtasks.vim

![Screenshot](/res/screenshot.png)

rtasks allows you to keep a simple plain text list of recurring tasks. 
Each task has a scheduled date. If you mark one as done, the scheduled 
date will change to the next calculated date using a certain pattern defined
right after the date. 

## Installation

### with vim-plug
Use this in your `~/.vimrc`:

`Plug 'mschwld/rtasks.vim'`

# Usage
After installation, use the `.tasks` extension to activate the plugin. An example is provided
in the `res/` folder.

## Types of recurring tasks
There are two options:

- patterns starting with `.+` will calculate the next date relative to the current date
- patterns starting with `++` will calculate the next date relative to the scheduled date

In theory, there are tasks where the break between each iteration matters, like a cleaning
task, because you want to wait for new dirt to arrive. But there are tasks where waiting 
is not mandatory, for example when paying the rent. If you pay it twice, you can skip the next 
iteration. 

## Keybindings 
You can mark a task (a line) as done by pressing `<Leader>tt`. You can change that in 
`ftplugin/tasks.vim`, line `233`.

## History file
Each time you mark a task as being done, an entry in a `.taskhistory` is created. If you 
ever wonder when was the last time you did a certain assignment, you can look it up there.

## Syntax highlighting
If a date corresponds to today or a past day, it will be highlighted in a red color. Every 
other date will appear in green color. Detected syntax errors will be highlighted with a red 
background color.

# Limitations and Todo
I failed to find a good solution for coloring past dates. I have to build regular expressions here, so
i hard-coded past years. There should be a better way of handling this, or at least this plugin should 
support a much larger range of past dates without hard-coding them.

Apart from this:
- disable/configure history file
- sorting items
