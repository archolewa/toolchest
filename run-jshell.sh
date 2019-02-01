#!/bin/sh

mvn -q dependency:build-classpath -Dmdep.outputFile=/tmp/classpath
/Library/Java/JavaVirtualMachines/jdk-11.0.1.jdk/Contents/Home/bin/jshell --class-path `cat /tmp/classpath | sanitize_classpath.py`
rm /tmp/classpath
