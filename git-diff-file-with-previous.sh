#! /bin/sh
# Shows the diff between the current version of the specified file and the same
# file from the previous commit.
git diff HEAD~1:$1 $1
