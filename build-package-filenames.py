#! /usr/bin/python
"""
A tiny little script that reads through the tags file and generates a file `.package-map`. This
file contains a mapping from package name to file in that package of the format:

java.util.Map /path/to/java/util/Map.java
java.util.Set /path/to/java/util/Set.java
com.example.Class /path/to/com/example/Class.java

This is used by my vim pluguin java-tide to rapidly figure out whether a given tag is in scope,
by checking if its file is in scope based on the imports.
"""
with open('tags', 'r') as tags:
    packages = ((line.split('\t')[0], line.split('\t')[1]) for line in tags if line.split("\t")[-1].strip() == "p")
    with open('.package-map', 'w') as package_map:
        for package_filename in packages:
            package_map.write(' '.join(package_filename) + '\n')
