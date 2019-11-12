#! /bin/sh
# A simple script (rather than an alias so that I can
# access it in vim) to generate git diffs in the format
# that I like: without colors, and character sequences
# that are easy to search for.

# The script takes a single argument: the branch to diff
# the current branch against.
git diff -D --no-color --patience --src-prefix="" --dst-prefix="" -W $1 
