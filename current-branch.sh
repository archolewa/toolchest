#! /bin/sh
# A script that returns the current branch.
git branch | ag "\*" | cut -d " " -f 2
