#! /bin/sh
# A script to make it easy to pull the current branch from origin.
# Takes one optional argument: The remote to pull from. If no argument
# is provided, defaults to `origin`.

if [[ "$#" == 0 ]]
then
    REMOTE=origin
else
    REMOTE=$1
fi
git fetch && git pull $REMOTE `current-branch.sh`
