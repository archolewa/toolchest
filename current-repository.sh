#! /bin/sh
# A simple script that returns the name of the current git repo (i.e. the current
# folder).
echo ${PWD##*/}
