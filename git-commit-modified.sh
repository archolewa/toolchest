#! /bin/sh
# Stages and commits all the modfiied files in the current directory.
git commit `git-modified.sh` && git commit
