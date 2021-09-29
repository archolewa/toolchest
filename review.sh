#! /bin/sh
# A simple script (rather than an alias so that I can
# access it in vim) to generate git diffs in the format
# that I like: without colors, and character sequences
# that are easy to search for.

# The script takes three arguments : the branch to diff
# the current branch against, the name of the repository 
# the code we're reviewing lives in, and the name of the
# current branch.


REPO=$(current-repository.sh)
BRANCH=$(current-branch.sh)
git diff -D --no-color --patience --src-prefix="" --dst-prefix="" -W $1 > ~/reviews/$REPO/pr-BRANCH.git.diff
git-diff-overview.sh $1 > ~/reviews/$REPO/pr-BRANCH.overview.diff

home_directory=$(echo ~)
echo $home_directory"/reviews/$REPO/pr-BRANCH.overview.diff"
echo $home_directory"/reviews/$REPO/pr-BRANCH.git.diff"
