# A script to make it easy to pull the current branch from origin.
# This could be an alias, except vim can't pick up aliases apparently.
git pull origin `git branch | ag "\*" | cut -d " " -f 2`
