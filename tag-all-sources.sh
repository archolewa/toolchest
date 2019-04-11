#! /bin/sh
if [ -f .classpath ]; then
    cat .classpath | xargs -I _ find _ -name *.java > tagfiles
    java-tags.sh $1 tagfiles
    rm tagfiles
else
    echo ".classpath not found. Skipping tag generation of dependencies."
fi
