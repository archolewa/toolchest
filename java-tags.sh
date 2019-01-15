#! /bin/sh
# Generates the tags for all the java files in the current directory, and adds
# them to the tags file. 
# Tags a single argument: The tags file to append the tags to
set -x
ctags --tag-relative=yes -a -f $1 --languages=java -R . 
