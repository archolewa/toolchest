#! /bin/sh
# A script that takes in an organization, a project and a a branch name, and
# generates a file `~/review/<project>/pr-<branch>.comments.diff.
# This file is a git diff as defined in review.sh, with the PR comments
# inserted into the diff at the appropriate line.
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

mkdir -p ~/reviews/$REPO
num=$(get-pr-number.sh $ORGANIZATION $REPO $BRANCH)
curl -s -1 -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3.diff" https://api.github.com/v3/repos/$ORGANIZATION/$REPO/pulls/$num > ~/reviews/$REPO/pr-$BRANCH.diff
extract_comments.py ~/reviews/$REPO/pr-$BRANCH.diff $ORGANIZATION $REPO $num $GITHUB_TOKEN api.github.com > ~/reviews/$REPO/pr-$BRANCH.comments.diff
rm -f ~/reviews/$REPO/pr-$BRANCH.diff
home_directory=$(echo ~)
echo $home_directory"/reviews/$REPO/pr-$BRANCH.comments.diff"
