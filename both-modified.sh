#!/bin/sh

# Returns a stream of file names that contain merge conflicts.
git status | grep "both modified" | cut -d ":" -f 2
