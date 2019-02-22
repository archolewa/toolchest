#! /bin/sh
# A simple shortcut for grepping all the Java files in the current
# directory.
grep $1 -r . --include=*.java
