#! /bin/sh
cat .classpath | xargs -I _ find _ -name *.java > tagfiles
java-tags.sh $1 tagfiles
rm tagfiles
