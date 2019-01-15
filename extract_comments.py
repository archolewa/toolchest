#! /usr/local/bin/python

"""
A script that takes two arguments:
1. The absolute path to the diff file to read.
2. The absolute path to a file containing the JSON blob containing all the comments on the PR as pulled from the github API: https://developer.github.com/enterprise/2.15/v3/#authentication

The script will extract the comments body and user ID and print out a copy of the diff file that includes the comments in the appropriate spot.
"""

import json
import sys

with open(sys.argv[1], 'r') as diff_file:
    diff_lines = diff_file.readlines()

with open (sys.argv[2], 'r') as github_blob:
    comments_blob = json.loads("\n".join(github_blob.readlines()))

commented_line = None
for comment in comments_blob:
    # If a comment doesn't have a position, it's outdated.
    if not comment["position"]:
        continue
    diff_hunk = comment["diff_hunk"].split("\n")
    count = 0
    for line_num, line in enumerate(diff_lines):
        if line.startswith(diff_hunk[0]):
            found_hunk = True
            commented_line = diff_hunk[-1].strip()
            if commented_line.startswith("+") or commented_line.starstwith("-"):
                commented_line = commented_line[1:]
        elif commented_line and commented_line in line:
            diff_lines.insert(line_num+1, "{# %s:%s #}\n" % (comment["user"]["login"], comment["body"]))
            commented_line = None
    if commented_line:
        print("WARNING: Failed to find blob for " + diff_hunk[0] + " body: " + comment["body"])

print(''.join(diff_lines))
