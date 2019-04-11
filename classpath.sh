#!/bin/sh
# A glorified alias for extracting the classpath and
# dumping it into a file.

if [ -f pom.xml ]; then
    mvn -q dependency:build-classpath -Dmdep.outputFile=.raw-classpath
else
    echo "Pom does not exist. Not building classpath."
fi
