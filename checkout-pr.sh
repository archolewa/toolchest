#! /bin/sh
# A script that takes in an organization, a project and a PR number, and
# checks out the branch associated with that PR.
# If only a PR number is supplied, then the current organization and repo will
# be used.

if [[ "$#" -eq 0 ]] 
then
    echo "Need at least a PR number."
    exit 0
fi
if [[ "$#" -eq 1 ]]
then
    ORGANIZATION=$(git remote -v | grep origin | head -n1 | cut -f 2 | cut -d " " -f1 | cut -d : -f2 | cut -d / -f1)
    REPO=$(current-repository.sh)
    PR_NUMBER=$1
else
    ORGANIZATION=$1
    REPO=$2
    PR_NUMBER=$3
fi
github-api.sh repos/$ORGANIZATION/$REPO/pulls/$PR_NUMBER  > /tmp/pr_information.json
BRANCH=$(jq ".head.ref" /tmp/pr_information.json)
BRANCH="${BRANCH%\"}"
BRANCH="${BRANCH#\"}"
REMOTE=$(jq ".head.repo.owner.login" /tmp/pr_information.json)
REMOTE="${REMOTE%\"}"
REMOTE="${REMOTE#\"}"
ORIGIN_OWNER=$(git remote -v | grep "^origin" | cut -d ":" -f2 | cut -d "/" -f1 | head -n1)
if [[ "$ORIGIN_OWNER" = "$REMOTE" ]]
then
    REMOTE="origin"
fi
git checkout $BRANCH && git pull $REMOTE $BRANCH
rm /tmp/pr_information.json
