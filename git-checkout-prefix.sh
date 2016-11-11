#!/bin/sh
# Allows me to type a unique prefix for a branch, and check it out. Used
# mostly because my git auto-complete is flaky with branch checkout.
BRANCH=$(git branch | grep $1)
echo "git checkout $BRANCH"
git checkout $BRANCH
