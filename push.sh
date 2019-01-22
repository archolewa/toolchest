# A script to make it easy to push the current branch up to origin.
# This could be an alias, except vim can't pick up aliases apparently.
BRANCH=$1
if [ -z $1 ]; then
 BRANCH="origin" 
fi
git push $BRANCH `git branch | fgrep "\*" | cut -d " " -f 2`
