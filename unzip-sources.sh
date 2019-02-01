#! /bin/sh
# Given a directory, cds into that directory and unzips all the
# -sources.jar files in the directory, if tide-sources doesn't
# already exist.
if [ ! -d "$1/tide-sources" ]
then
    if test -n "$(find . -maxdepth 1 -name '*-sources.jar' -print -quit)"
    then
        cd $1
        unzip -qq -n -d tide-sources '*-sources.jar'
        cd -
    fi
fi
