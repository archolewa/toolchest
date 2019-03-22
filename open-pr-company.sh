#! /bin/sh
# Creates a PR in the specified repository of the
# specified branch against the specified branch (defaulting
# to master).
# The script takes the following arguments:
# 1. The organization containing the repository.
# 2. The repository to open a PR in.
# 3. The branch containing new code to be merged in.
# 4. The branch to open a PR against.
# $4 is optional and defaults to $(master). If
# no arguments are supplised, the current organization, the current repository,
# the current branch, and $(master) are used.
# Note: There is currently a bug.  This will barf if any quotes are included in
# the body of the commit message.
set -e
if [[ "$#" == 0 ]]
then
    ORGANIZATION=$(git remote -v | grep origin | head -n1 | cut -f2 | cut -d " " -f1 | cut -d : -f2 | cut -d / -f1)
    REPO=$(current-repository.sh)
    BRANCH=$(current-branch.sh)
    BASE=master
else
    ORGANIZATION=$1
    REPO=$2
    BRANCH=$3
    if [[ "$#" == 3 ]]
    then
        BASE=master
    else
        BASE=$4
    fi
fi
COMMIT_BODY=$(git log HEAD~1..HEAD --pretty=format:%b | sed s/'"'/'\\"'/g | tr \\n \& | sed s/\&/\\\\n/g)
COMMIT_JSON='{"title":''"'$(git log HEAD~1..HEAD --pretty=format:%f)'"'',''"head":''"'$BRANCH'"'',''"base":''"'$BASE'"'',''"maintainer_can_modify":true,''"body":"'$COMMIT_BODY'"}'
curl -XPOST -1 -v -H "Authorization: token $GITHUB_TOKEN" --data-binary "$COMMIT_JSON" https://api.github.com/v3/repos/$ORGANIZATION/$REPO/pulls
get-pr-link.sh $ORGANIZATION $REPO $BRANCH
