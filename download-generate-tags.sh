#! /bin/sh
# Downloads and generates tags for all sources in the 
# current project.
# Also generates and saves the scopes for each class in
# the project.
# Takes one argument: The fully-qualfied path to the tags file
# to store the tags in.
set -x
classpath.sh
cleanup_classpath.py
download_sources.sh 
unzip-all-sources.sh 
tag-all-sources.sh $1