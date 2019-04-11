#! /bin/sh
# A simple script that returns
# the number of a PR based on its branch. Very useful to chain with $(get-comments).
# Takes the following arguments:
# 1. The github organization.
# 2. The repo
# 3. The branch whose number is desired
# If no arguments are supplied, the current organization branch and repo will be used.
if [[ "$#" == 0 ]]
then
    ORGANIZATION=$(git remote -v | grep origin | head -n1 | cut -f2 | cut -d " " -f1 | cut -d : -f2 | cut -d / -f1)
    REPO=$(current-repository.sh)
    BRANCH=$(current-branch.sh)
else
    ORGANIZATION=$1
    REPO=$2
    BRANCH=$3
fi
github-api.sh repos/$ORGANIZATION/$REPO/pulls | jq "map(select(.head.ref == \"$BRANCH\")) | .[].number"
