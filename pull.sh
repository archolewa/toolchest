# A script to make it easy to pull the current branch from origin.
# This could be an alias, except vim can't pick up aliases apparently.
git pull origin `git branch | fgrep "*" | cut -d " " -f 2`
