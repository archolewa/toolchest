#!/bin/sh

# A shortcut for starting a debugging session. The script takes a single
#argument: The test file to run.
mvn -q test -Dmaven.surefire.debug -Dcheckstyle.skip=true -Dtest=$1
