#! /bin/sh
# Generates a cscope file.
find . -name '*.java' > cscope.files && cscope -b -q && rm cscope.files
