#! /bin/sh
# Generates the tags for all the java files in the current directory, and adds
# them to the tags file. Perhaps someday I'll take in arguments to specify
# both the tags file to use, and the extension to use.
# As is, this exists as a script (rather than an alias) so that I can invoke
# it from within vim.
set -x
ctags --tag-relative=yes -a -f $1 --languages=java -R . 
