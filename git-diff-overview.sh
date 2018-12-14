#! /bin/sh
# Provides a summary of the changes between the current branch, and the 
# specified branch.
git diff --stat=1024 $1 --exit-code -a
