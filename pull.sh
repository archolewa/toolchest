# A script to make it easy to pull the current branch from origin.
# This could be an alias, except vim can't pick up aliases apparently.
git fetch && git pull origin `current-branch.sh`
