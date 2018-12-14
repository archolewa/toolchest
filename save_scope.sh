#!/bin/sh
# A simple script that generates the scope for every class in the current Java
# project, and saves it to a file called .scope.
build_scope.py .classpath `find . -name "*.java"` > .scope
