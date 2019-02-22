#! /bin/sh
# Given a directory, cds into that directory and unzips all the
# -sources.jar files in the directory, if tide-sources doesn't
# already exist.
if [ ! -d "$1/tide-sources" ]
then
    cd $1
    SOURCES_JAR=$(find . -maxdepth 2 -name '*-sources.jar' -print -quit | head -n1)
    if test -n "$SOURCES_JAR"
    then
        unzip -qq -n -d tide-sources $SOURCES_JAR
    fi
    cd -
fi
