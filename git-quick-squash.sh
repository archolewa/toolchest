#!/bin/sh
# A simple script to make it easy to squash unstaged changes into the previous
# commit.
git add . && git commit -m "fixup" && git rebase -i HEAD~2
