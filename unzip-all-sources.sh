#! /bin/sh
# Iterates through every file in the .classpath file and
# extracts the sources.
cat .classpath | xargs -I _ unzip-sources.sh _
