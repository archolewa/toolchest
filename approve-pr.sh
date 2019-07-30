#! /bin/sh
# Approves the PR for the specified repository and branch. Takes
# the following arguments:
# 1. The github organization this repository belongs to
# 2. The repository with a PR to approve.
# 3. The branch of the PR to approve.
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
num=$(get-pr-number.sh $ORGANIZATION $REPO $BRANCH)
PAYLOAD='{"event":"APPROVE"}'
curl -XPOST -1 -H "Authorization: token $GITHUB_TOKEN" --data-binary "$PAYLOAD" https://api.github.com/repos/$ORGANIZATION/$REPO/pulls/$num/reviews
