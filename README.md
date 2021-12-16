# About rtasks.vim
rtasks allows you to keep a simple plain text list of recurring tasks. 
Each task has a scheduled date. If you mark it as done, the scheduled 
date will change to the next scheduled date using a certain pattern. 
You give your files the `rtasks` extension to activate the plugin and syntax 
highlighting. This plugin uses nothing but Vimscript and has no dependencies.

# Types of recurring tasks
You have two options:

- patterns starting with `.+` will calculate the next date relative to the current date
- patterns starting with `++` will calculate the next date relative to the scheduled date

In theory, there are tasks where the break between each iteartion matters, like cleaning
your home. Most of the time it doesn't really make sense to clean something two times in 
a row, because you want wo wait for new dirt to arrive. But there are tasks where waiting 
is not mandatory, for example paying the rent. If you pay it twice, you can skip the next 
iteration.

# Keybindings 
You can mark a task (a line) as done by pressing `<Leader>tt`.

# History file
Each time you tick a task as being done, an entry in a `.taskhistory` is created. If you 
ever wonder when was the last time you did a certain assignment, you can look it up there.

# Details on the alogrithm
The calculations in this plugin are rather simple. They only know the Gregorian calendar and 
respect the leap years. If you decide a task should repeat every month, it is not clear what 
a month is. It could be 30, 31, 28 or 29 days. Fair enough, this plugin will skip a day if 
the next month has less days than the month with the scheduled task. 

# Todo
- the history file should reference the filename of the tasks file
- folding, getting more structure to the file
- create options to configure

# Syntax highlighting
Days, which are the present day or days in the past, will be highlighted in a red color. Every 
other date will appear in green color. Dates using a wrong, or better, not yet supported format, 
will be highlighted with a red background. 

# Limitations
I failed to find a good solution for coloring past dates. I have build regular expressions here, so
i hard-coded past years. There should be a better way of handling this. At least this plugin should 
support a much larger range of past dates without hard-coding them.
