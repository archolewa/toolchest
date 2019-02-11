#! /bin/sh
# Compiles the current maven project and downloads
# all the sources.
mvn -q dependency:sources # dependency:resolve -Dclassifier=javadoc # Don't want to do this yet. Not until we've implemented the javadoc script.
