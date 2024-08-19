# gitsync

simple, small plugin that informs you of whether a chosen local git repository is out of "sync" with its corresponding remote. 

i supply one function, `check_remote(loc)` that triggers this action. all it is doing is running `git fetch && git status` under the hood.

can be configured to run on open (that's how i have it setup) or based on a keybinding, that's up to you

depends on plenary.nvim
