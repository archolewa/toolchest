#! /bin/sh
# Helps me find HEAD on a complex git tree.
git-overview.sh | grep $1 $2 HEAD
