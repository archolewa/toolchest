#!/bin/sh

# Runs tests in a maven project before pushing.

mvn clean test && mvn clean && push.sh
