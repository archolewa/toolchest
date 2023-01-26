#! /bin/sh

# A simple script that allows me to run a java class/jar/whatever with debug turned on, accessible
# at port 8000.

echo "Attach debugger on port 8000."
java -Xdebug -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=y $1
