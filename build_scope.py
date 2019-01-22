#! /home/y/bin/python
"""
This script builds the dependency tree for a Java project for use in determining
whether a given tag is in scope in the current file.

The script takes the following arguments:
1. The path to a file that contains the paths to the sources of the project's dependencies,
    one path per line.
2. Optionally the name of a file that contains an earlier dependency tree for this project
    (this allows us to perform deltas very rapidly)
3. A list of 1 or more Java files whose dependencies should be derived.

It prints a sequence of comma separated lines.  Each line is of the following
format:
/absolute/path/to/class,/absolute/path/to/class/can/see/it1,/absolute/path/to/class/can/see/it2,...

We also print out lines for each dependency. So effectively this script builds
a map from files to the files that can see them through their dependencies.

The scope is derived via a memoized depth-first search through the imports
of each file, using the classpath to resolve imports into absolute paths.

We also need to add all the files in the current package to the scope. For this,
it's probably sufficient to just grab all the files in the same directory as the
current file, and if directory contains `src/test`, all the files included in
the parallel directory under `src/main`.
"""

import sys
import os

def no_more_imports(line):
    return line.startswith(("public", "private", "protected", "class"))

def build_absolute_paths(relative_path, classpath):
    absolute_paths = (os.path.join(path, relative_path) for path in classpath)
    return [path for path in absolute_paths if os.path.exists(path)]

def references(classfile, file):
    classname = os.path.splitext(file)[0]
    with open(classfile, 'r') as class_definition:
        return classname in class_definition.read()

def build_dependency_tree(classpath, dependency_tree, classes, levelsdeep=999):
    class_queue = set(classes)
    while class_queue:
        classfile = class_queue.pop()
        if dependency_tree.has_key(classfile):
            continue
        dependency_tree[classfile] = set()
        with open(classfile, 'r') as java_class:
            for line in java_class:
                if no_more_imports(line):
                    break
                if line.startswith("import"):
                    # We need to go from "import com.package.Test; to
                    # com/package/Test.java
                    if "static" in line:
                        package = ".".join(line.split()[2][:-1].split(".")[:-1])
                    else:
                        package = line.split()[1][:-1]
                    relative_path = os.path.join(*package.split(".")) + ".java"
                    absolute_paths = build_absolute_paths(relative_path, classpath)
                    dependency_tree[classfile].update(
                        file
                        for file in absolute_paths
                        if not os.path.samefile(classfile, path)
                    )
                    class_queue.update(absolute_paths)
                elif line.startswith("package"):
                    package = line.split()[1][:-1]
                    relative_path = os.path.join(*package.split("."))
                    absolute_paths = build_absolute_paths(relative_path, classpath)
                    for path in absolute_paths:
                        files = [
                            os.path.join(path, file)
                            for file in os.listdir(path)
                            if file.endswith(".java") and references(classfile, file)
                        ]
                        dependency_tree[classfile].update(
                            file
                            for file in files
                            if not os.path.samefile(classfile, file)
                        )
                        class_queue.update(files)

def prepopulate_dependencies(dependencies, requested_files):
    with open(sys.argv[2]) as dependency_tree:
        for line in dependency_tree:
            classes = line.split(",")
            dependencies[classes[0]] = classes[1:]
        for classfile in requested_files:
            del dependencies[classfile]

def load_classpath(classpath):
    with open(classpath, 'r') as classpath_file:
        classpath = classpath_file.readlines()
        classpath.append(os.path.join(os.getcwd(), "src/main/java"))
        classpath.append(os.path.join(os.getcwd(), "src/test/java"))
        # TODO: Pull these out into configuration variables.
        classpath.append("/Users/acholewa/gozer/flurry/dbAccessLayer/")
        classpath.append("/Users/acholewa/work/kafka/connect")
        standard_library = os.path.join(
            os.path.expanduser("~"),
            "sources/java-standard-library"
        )
        classpath.append(standard_library)
    return classpath

def pivot_dependencies(dependencies):
    pivoted_dependencies = [None] * len(dependencies)
    for javaclass, classdependencies in enumerate(dependencies):
        for dependency in classdependencies:
            if pivoted_dependencies[dependency] is None:
                pivoted_dependencies[dependency] = set()
            pivoted_dependencies[dependency].add(javaclass)
    for javaclass, classdependencies in enumerate(pivoted_dependencies):
        visible_to = classdependencies
        if visible_to is None:
            continue
        new_visible_to = set(visible_to)
        while True:
            for visible in visible_to:
                visible_to_visible = pivoted_dependencies[visible]
                if visible_to_visible is not None:
                    new_visible_to.update(visible_to_visible)
            if new_visible_to == visible_to:
                break
            visible_to = set(new_visible_to)
        pivoted_dependencies[javaclass] = visible_to
    return pivoted_dependencies

if __name__ == "__main__":
    classpath = load_classpath(sys.argv[1])
    java_file_index = 2 if sys.argv[2].endswith("java") else 3
    requested_files = sys.argv[java_file_index:]
    dependencies = {}
    if java_file_index == 3:
        prepopulate_dependencies(dependencies, requested_files)
    sys.stderr.write("Building dependency tree.")
    build_dependency_tree(classpath, dependencies, requested_files)
    sys.stderr.write("Compressing dependency tree.")
    classnumbers = {}
    count = 0
    for classfile in dependencies:
        classnumbers[classfile] = count
        count += 1
    compressed_dependencies = [None] * len(dependencies)
    for classfile in dependencies:
        compressed = set()
        for dependency in dependencies[classfile]:
            compressed.add(classnumbers[dependency])
        compressed_dependencies[classnumbers[classfile]] = compressed
    sys.stderr.write("Pivoting dependencies.")
    pivoted_dependencies = pivot_dependencies(compressed_dependencies)
    with open(".scopemappings", "w") as scopemappings:
        for classfile in classnumbers:
            line = ":".join([classfile, str(classnumbers[classfile])])
            scopemappings.write(line + "\n")
    sys.stderr.write("Writing pivoted dependencies.")
    for classnumber, dependencies in enumerate(pivoted_dependencies):
        if dependencies is None:
            continue
        dependencies_string = ",".join(str(number) for number in dependencies) + "," # Added to simplify search regex.
        print ",".join([str(classnumber), dependencies_string])
