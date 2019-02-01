#! /bin/sh
# Generates the tags for all the java files in the current directory, and adds
# them to the tags file.
# Requires a single argument: The tags file to append the tags to
# Also takes an optional second argument: The name of a file containing all the
# files that need to be tagged.
if [[ $# == 2 ]]
then
    ctags --tag-relative=yes -a -f $1 --languages=java -R -L $2
else
    ctags --tag-relative=yes -a -f $1 --languages=java -R .
fi
