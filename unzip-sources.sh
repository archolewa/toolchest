#! /bin/sh
# Given a directory, cds into that directory and unzips all the 
# -sources.jar files in the directory.
cd $1
unzip -qq -n -d tide-sources '*-sources.jar'
