#!/bin/sh
# A glorified alias for extracting the classpath and
# dumping it into a file.
mvn -q dependency:build-classpath -Dmdep.outputFile=.raw-classpath
