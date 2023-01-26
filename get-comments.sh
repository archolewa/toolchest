#! /bin/sh
# A script that takes in an organization, a project, and two branch names (or
# commit names, or tag names or whatever), and
# generates a file `~/review/<project>/pr-<branch>.comments.diff.
# This file is a git diff as defined in review.sh between the two branches, with the PR 
# comments
# inserted into the diff at the appropriate line.
# If no arguments are supplied, the current organization branch and repo will be used.
# If 1 argument is supplied, it's assumed to be the branch to perform the diff against.
# If the second branch is not supplied, the review is performed against master.

if [[ "$#" == 0 ]]
then
    ORGANIZATION=$(git remote -v | grep origin | head -n1 | cut -f 2 | cut -d " " -f1 | cut -d : -f2 | cut -d / -f1)
    REPO=$(current-repository.sh)
    BRANCH=$(current-branch.sh)
    BASE_BRANCH=master
elif [[ "$#" == 3 ]]
then
    ORGANIZATION=$1
    REPO=$2
    BRANCH=$3
    BASE_BRANCH=master
elif [[ "$#" == 4 ]]
then
    ORGANIZATION=$1
    REPO=$2
    BRANCH=$3
    BASE_BRANCH=$4
elif [[ "$#" == 1 ]]
then
    ORGANIZATION=$(git remote -v | grep origin | head -n1 | cut -f 2 | cut -d " " -f1 | cut -d : -f2 | cut -d / -f1)
    REPO=$(current-repository.sh)
    BRANCH=$(current-branch.sh)
    BASE_BRANCH=$1
fi

mkdir -p ~/reviews/$REPO
# num=$(get-pr-number.sh $ORGANIZATION $REPO $BRANCH)
# curl -s -1 -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3.diff" https://api.github.com/repos/$ORGANIZATION/$REPO/pulls/$num > ~/reviews/$REPO/pr-$BRANCH.diff
# extract_comments.py ~/reviews/$REPO/pr-$BRANCH.diff $ORGANIZATION $REPO $num $GITHUB_TOKEN api.github.com > ~/reviews/$REPO/pr-$BRANCH.github.diff
rm -f ~/reviews/$REPO/pr-$BRANCH.diff
home_directory=$(echo ~)
review.sh $BASE_BRANCH > ~/reviews/$REPO/pr-$BRANCH.git.diff
git-diff-overview.sh $BASE_BRANCH > ~/reviews/$REPO/pr-$BRANCH.overview.diff
echo $home_directory"/reviews/$REPO/pr-$BRANCH.overview.diff"
echo $home_directory"/reviews/$REPO/pr-$BRANCH.git.diff"
echo $home_directory"/reviews/$REPO/pr-$BRANCH.github.diff"
