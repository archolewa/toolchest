#!/bin/sh
# A glorified alias for extracting the classpath and 
# dumping it into a file.
mvn dependency:build-classpath -Dmdep.outputFile=.raw-classpath
