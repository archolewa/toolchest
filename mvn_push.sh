#!/bin/sh

# Runs tests in a maven project before pushing.

mvn -q test | tee /tmp/mvn_output && push.sh
