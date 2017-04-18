#!/bin/sh
# Removes all branches that have been merged into master.
CURRENT_BRANCH=`git branch | grep --color=never \* | cut -d '*' -f 2`
git checkout master && git pull origin master && git branch --merged | grep -v "master" | xargs -n 1 git branch -d && git checkout $CURRENT_BRANCH
