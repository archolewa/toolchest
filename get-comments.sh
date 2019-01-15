#! /bin/sh
# A script that takes in an organization, a project and a PR number, and 
# generates a file `~/review/<project>/pr<number>comments.diff.
# This file is a git diff as defined in review.sh, with the PR comments
# inserted into the diff at the appropriate line.

mkdir -p ~/reviews/$2
corp-github-api.sh "repos/$1/$2/pulls/$3/comments > ~/reviews/$2/pr$3.comments
review.sh master > ~/reviews/$2/pr$3.diff
extract-comments.py ~/reviews/$2/pr$3.diff ~/reviews/$2/pr$3.comments > ~/reviews/$2/pr$3.comments.diff
rm ~/reviews/$2/pr$3.comments
rm ~/reviews/$2/pr$3.diff
