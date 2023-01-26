#! /usr/local/bin/python
"""
Reads a classpath from a local .classpath file, and performs
some transformations to make it easier to work with:

1. Strips the jar from each directory
2. Puts each directory on its own line.
"""

import os.path

classpaths = []
try:
    with open(".raw-classpath", "r") as classpathfile:
        for classpath in classpathfile:
            classpaths.append("\n".join(set(os.path.dirname(jar) for jar in classpath.split(":"))))
except IOError:
    print(".raw-classpath does not exist. Skipping cleanup.")
else:
    classpaths = "\n".join(classpaths)
    with open(".classpath", "w") as classpathfile:
        classpathfile.write(classpaths)
