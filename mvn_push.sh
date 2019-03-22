#!/bin/sh

# Runs tests in a maven project before pushing.

mvn -q test && push.sh
