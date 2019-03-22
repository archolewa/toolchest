#! /bin/sh
# A script that takes in an organization, a project and a a branch name, and
# posts the comments in `~/review/<project>/pr-<branch>.comments.diff to the
# PR.
# If no arguments are supplied, the current organization branch and repo will be used.
if [[ "$#" == 0 ]]
then
    ORGANIZATION=$(git remote -v | grep origin | head -n1 | cut -f 2 | cut -d " " -f1 | cut -d : -f2 | cut -d / -f1)
    REPO=$(current-repository.sh)
    BRANCH=$(current-branch.sh)
else
    ORGANIZATION=$1
    REPO=$2
    BRANCH=$3
fi

num=$(get-pr-number.sh $ORGANIZATION $REPO $BRANCH)
commit_id=$(git rev-parse HEAD)
post_comments.py ~/reviews/$REPO/pr-$BRANCH.comments.diff $ORGANIZATION $REPO $num $commit_id $GITHUB_TOKEN api.github.com
