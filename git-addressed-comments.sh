#!/bin/sh
# A simple script that takes a branch name, and commits all the current changes
# under the message "Addressed comments" and pushes them to the specified branch
# at remote `origin`.
git add . && git commit -m "Addressed comments" && git push origin $1
