#! /bin/sh
# Iterates through every file in the .classpath file and
# extracts the sources.
if [ -f .classpath ]; then
    cat .classpath | xargs -I _ unzip-sources.sh _
else
    echo ".classpath not found. Skip source unzipping."
fi
