#! /bin/sh

# Runs the specified test (classname without type extension, e.g. "GroovyTestSpec" as opposed
# to "GroovyTestSpec.groovy"), except have mvn wait for a debugger to attach on port 8000.
mvnDebug test -Dtest=$1 -DforkCount=0 -DreuseForks=false
