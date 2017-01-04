#!/bin/sh
# Removes all branches that have been merged into master, except for the current
# branch and master itself.
git branch --merged | grep -v "\*" | grep -v "master" | xargs -n 1 git branch -d
