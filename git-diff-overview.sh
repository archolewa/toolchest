#! /bin/sh
# Provides a summary of the changes between the current branch, and the
# specified branch.
git diff --stat=1024,512 --exit-code -a --compact-summary --dirstat $1
