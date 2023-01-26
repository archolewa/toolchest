#!/bin/sh
# Given the path to a YAML file, validates the file. If the 
# script does nothing (and has a 0 return code) the YAML is 
# valid. Otherwise, it will print the errors.
python -c 'import yaml, sys; yaml.safe_load(sys.stdin)' < $1
